Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :developer unless Rails.env.production?
  provider :twitter, "hbjDUzLxirP95IJKk9vbeg", "v38pODXYzUkpDZcDwUEazoPZwL2rZlhO124bjg0I"
end