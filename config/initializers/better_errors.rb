if ENV["NO_BETTER_ERRORS"]
  Kbk::Application.config.middleware.delete "BetterErrors::Middleware"
end
