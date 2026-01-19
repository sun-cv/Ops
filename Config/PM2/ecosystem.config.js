module.exports = {
  apps: [
    {
      name: "Geo",
      script: "C:/Dev/Projects/Geo/prod/main.js",
      cwd: "C:/Dev/Projects/Geo/prod",
      out_file: "C:/Ops/Logs/Projects/Geo/out.log",
      error_file: "C:/Ops/Logs/Projects/Geo/error.log",
      log_date_format: "MM-DD-YY",
      merge_logs: true,
      time: false,
    }
  ]
}