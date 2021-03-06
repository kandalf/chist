module ChistApp
  module Helpers
    def self.init_environment(env)
      self.set_env(env)

      db_params = {
        'host' => ENV["DATABASE_HOST"],
        'port' => ENV["DATABASE_PORT"],
        'user' => ENV["DATABASE_USER"],
        'password' => ENV["DATABASE_PASS"],
        'db_name' => ENV["DATABASE_NAME"]
      }

      ChistApp::Database.connect db_params
    end

    def self.set_env(env)
      filename = env.to_s + ".env.sh"

      if File.exists? filename
        env_vars = File.read(filename)
        env_vars.each_line do |var|
          name, value = var.split("=")
          if name && value
            ENV[name.strip] = value.strip
          end
        end
      end
    end
  end
end
