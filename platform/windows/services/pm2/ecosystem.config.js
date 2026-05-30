


module.exports = {
  apps: [
    {
      name: "Geo",
      script: "C:/sun/dev/projects/geo/prod/main.js",
      cwd: "C:/sun/dev/projects/geo/prod",
      out_file: "C:/sun/logs/projects/geo/out.log",
      error_file: "C:/sun/logs/projects/geo/error.log",
      log_date_format: "MM-DD-YY",
      merge_logs: true,
      time: false,
    }
  ]
}
