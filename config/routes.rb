Rails.application.routes.draw do
  get '/check_balance/:account_number', to: 'customers#check_balance'
  post '/transfer_money', to: 'customers#transfer_money'
  put '/update_balance/:account_number', to: 'customers#update_balance'
  post '/generate_account_numbers', to: 'customers#generate_account_numbers'
end
