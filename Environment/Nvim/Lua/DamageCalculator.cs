using System;
using System.Collections.Generic;
using UnityEngine;



public class DamageCalculator : RegisteredService, IServiceLoop
{    
    readonly List<DamageContext> queue = new();
    readonly List<(Func<Actor, bool>, IDamageCalculator)> calculators = new();

    // ===============================================================================

    public DamageCalculator()
    {
        RegisterDamageCalculators();

        Link.Global<CalculateDamage>(HandleDamageCalculatorEvent);

        Services.Lane.Register(this);
    }

    // ===============================================================================

    public void Loop()
    {
        ProcessQueue();
    }

    // ===============================================================================

    void ProcessQueue()
    {
        foreach (var context in queue)
        {
            ProcessContext(context);
        }

        queue.Clear();
    }

    void ProcessContext(DamageContext context)
    {

        foreach(var (predicate, calculator) in calculators)
        {
            if (!predicate(context.Target))
                continue;

            calculator.Calculate(context);
        }
        
        SendResolveDamage(context);
    }

    // ===============================================================================
    //  Events
    // ===============================================================================

    void HandleDamageCalculatorEvent(CalculateDamage message)
    {
        queue.Add(message.Context);
    }

    void SendResolveDamage(DamageContext context)
    {
        Emit.Global(new ResolveDamage(context));
    }

    // ===============================================================================
    //  Helpers
    // ===============================================================================

    void RegisterDamageCalculators()
    {
        Register((actor) => actor is IShield, new ResourceDamageCalculator(ResourceType.Shield));
        Register((actor) => actor is IArmor,  new ResourceDamageCalculator(ResourceType.Armor ));
        Register((actor) => actor is IHealth, new ResourceDamageCalculator(ResourceType.Health));
    }

    void Register(Func<Actor, bool> func, IDamageCalculator calculator)
    {
        calculators.Add((func, calculator)); 
    }

    // ===============================================================================

    readonly Logger Log = new(LogSystem.Combat, LogLevel.Debug);

    public override void Dispose()
    {
        Services.Lane.Deregister(this);
    }

    public UpdatePriority Priority => ServiceUpdatePriority.DamageCalculator;
}



// ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
//                                         Events
// ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬


public readonly struct CalculateDamage : IMessage
{
    public DamageContext Context            { get; init; }

    public CalculateDamage(DamageContext context)
    {
        Context = context; 
    }
}


// ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
//                                       Processors
// ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬


public interface IDamageCalculator
{
    void Calculate(DamageContext context);
}
        


public class ResourceDamageCalculator : IDamageCalculator
{
    readonly ResourceType resource;

    // ===============================================================================

    public ResourceDamageCalculator(ResourceType resource)
    {
        this.resource = resource;
    }

    // ===============================================================================

    public void Calculate(DamageContext context)
    {
        switch(CanCalculateDamage(context))
        {
            case true: ProcessDamage(context); break;
            case false: break;
        }
    }

    // ===============================================================================

    void ProcessDamage(DamageContext context)
    {
        foreach(var component in context.Package.Components)
        {
            CalculateDamage(context, component);
        }
    }

    void CalculateDamage(DamageContext context, DamageComponent component)
    {
        var rule                        = DamageRules.Get(resource, component.Mode, component.Damage.Element);

        if (DamageGated(rule))
            return;

        var result                      = context.Result.Components[component];

        CreateResultEntries(result);

        var health                      = DamageRules.Target[resource](context.Target);
        var damage                      = result.RemainingDamage;   

        var multiplier                  = rule.Multiplier;
        var totalDamage                 = MathF.Round(damage * multiplier);

        float absorbed                  = Mathf.Min(totalDamage, health);


        result.Damage[resource]        += absorbed;
        result.Broken[resource]         = health <= absorbed;
    
        DamageRuleApplication(DamageContext(context, component, result), rule);
    }

    void CreateResultEntries(DamageComponentResult result)
    {
        if (!result.Damage.ContainsKey(resource))
            result.Damage.Add(resource, 0);

        if (!result.Broken.ContainsKey(resource))
            result.Damage.Add(resource, 0);
    }

    DamageApplicationContext DamageContext(DamageContext context, DamageComponent component, DamageComponentResult result)
    {
        return new()
        {
            Target      = context.Target,
            Resource    = resource,
            Component   = component,
            Result      = result
        };
    }

    void DamageRuleApplication(DamageApplicationContext context, DamageRule rule)
    {
        foreach (var transformSet in DamageRules.Transforms)
        {
            switch(transformSet.Condition(rule)) 
            {
                case true:  foreach ( var transform in transformSet.OnTrue ) transform(context);    break;
                case false: foreach ( var transform in transformSet.OnFalse) transform(context);    break;
            }
        }
    }

    // ===============================================================================
    //  Predicates
    // ===============================================================================

    bool CanCalculateDamage(DamageContext context)
    {   
        if (!DamageRules.Targeting[resource](context.Target))
            return false;

        if (DamageRules.ResourceSpecific.TryGetValue(resource, out var rules))
        {
            foreach (var rule in rules)
            {
                if (!rule(context))
                    return false;
            }
        }        

        return true;
    }

    bool DamageGated(DamageRule rule)
    {
        foreach(var gate in DamageRules.Gates)
        {
            if (gate(rule))
                return true;
        }

        return false;
    }
}



// ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
//                                          Maps
// ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬


public class DamageRule
{
    public float Multiplier                 { get; init; }
    public bool Unblockable                 { get; init; }
    public bool Piercing                    { get; init; }
    public bool AbsorbOnBreak               { get; init; }

    public static readonly DamageRule Default = new() { Multiplier = 1 };
}


public static class DamageRules
{

    public static readonly Dictionary<ResourceType, Dictionary<(DamageMode, DamageElement), DamageRule>> Damage = new()
    {
        [ResourceType.Health]   = new() 
        {
            [(DamageMode.DoT,       DamageElement.Fire)]        = new() { Piercing = true },
        },
        [ResourceType.Armor]    = new()
        {
            [(DamageMode.DoT,       DamageElement.Fire)]        = new() { Piercing = true }
        },
        [ResourceType.Shield]   = new()
        {
            [(DamageMode.DoT,       DamageElement.Fire)]        = new() { Unblockable = true },

            [(DamageMode.DoT,       DamageElement.Shock)]       = new() { Multiplier = 1.5f },      
            [(DamageMode.Laser,     DamageElement.Shock)]       = new() { Multiplier = 1.5f },
            [(DamageMode.Direct,    DamageElement.Shock)]       = new() { Multiplier = 1.5f },    
        }
    };

    public static DamageRule Get(ResourceType type, DamageMode mode, DamageElement element) { DamageRule rule = null; Damage.TryGetValue(type, out var ruleset); ruleset?.TryGetValue((mode, element), out rule); return rule ?? DamageRule.Default;}


    public static readonly Dictionary<ResourceType, Func<Actor, float>> Target                  = new()
    {
        [ResourceType.Shield] = (target) => ((IShield)target).Shield,
        [ResourceType.Armor]  = (target) => ((IArmor) target).Armor,
        [ResourceType.Health] = (target) => ((IMortal)target).Health,
    };


    public static readonly Dictionary<ResourceType, Func<Actor, bool>> Targeting               = new()
    {
        [ResourceType.Shield] = (target) => target is IShield actor && actor.Shield > 0,
        [ResourceType.Armor]  = (target) => target is IArmor  actor && actor.Armor  > 0,
        [ResourceType.Health] = (target) => target is IMortal actor && actor.Health > 0,
    };

    public static readonly Dictionary<ResourceType, List<Func<DamageContext, bool>>> ResourceSpecific   = new()
    {
        [ResourceType.Shield] = new()
        {
            (context) => context.Result.Blocked,
        }
    };

    public static readonly List<Func<DamageRule, bool>> Gates = new()
    {
        (rule) => rule.Unblockable,
    };


    public static readonly List<DamageApplicationEntry> Transforms = new()
    {
        new () 
        {
            Condition   = (rule)    => rule.Piercing,
            OnTrue      = new(),
            OnFalse     = new()
            {
                (context)   => 
                { 
                    context.Result.RemainingDamage -= context.Result.RemainingDamage - context.Result.Damage[context.Resource]; 
                }
            }
        },
        new () 
        {
            Condition   = (rule)    => rule.AbsorbOnBreak,
            OnTrue      = new()
            {
                (context)   => 
                { 
                    if (context.Result.Damage[context.Resource] < Target[context.Resource](context.Target))
                        return;

                    context.Result.Broken[context.Resource] = true;
                    context.Result.Damage[context.Resource] = context.Result.RemainingDamage; context.Result.RemainingDamage = 0; 
                }
            },
            OnFalse     = new()
            {
                (context)   =>
                {
                    if (context.Result.Damage[context.Resource] < Target[context.Resource](context.Target))
                        return;

                    context.Result.Broken[context.Resource] = true;
                }
            }
        },
    };
}

public struct DamageApplicationEntry
{
    public Func<DamageRule, bool>                                   Condition;
    public List<Action<DamageApplicationContext>> OnTrue;
    public List<Action<DamageApplicationContext>> OnFalse;
}

public struct DamageApplicationContext
{
    public Actor Target                 { get; set; }
    public ResourceType Resource        { get; set; }
    public DamageComponent Component    { get; set; }
    public DamageComponentResult Result { get; set; }
}
