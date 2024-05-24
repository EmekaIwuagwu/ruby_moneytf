# app/controllers/customers_controller.rb
class CustomersController < ApplicationController
    def check_balance
      customer = Customer.find_by(account_number: params[:account_number])
      render json: { balance: customer&.balance || 0.00 }
    end
  
    def transfer_money
      sender = Customer.find_by(account_number: params[:sender_account_number])
      receiver = Customer.find_by(account_number: params[:receiver_account_number])
  
      if sender && receiver && sender.balance >= params[:amount].to_f
        sender.balance -= params[:amount].to_f
        receiver.balance += params[:amount].to_f
        sender.save
        receiver.save
        render json: { message: 'Transfer successful' }
      else
        render json: { error: 'Insufficient balance or invalid account number' }, status: :unprocessable_entity
      end
    end
  
    def update_balance
      customer = Customer.find_by(account_number: params[:account_number])
      if customer
        customer.update(balance: params[:balance])
        render json: { message: 'Balance updated successfully' }
      else
        render json: { error: 'Customer not found' }, status: :not_found
      end
    end
  
    def generate_account_numbers
        10.times do
          account_number = "2030#{SecureRandom.random_number(10**11).to_s.rjust(11, '0')}"
          fullname = Faker::Name.name
          address = Faker::Address.street_address
          city = Faker::Address.city
          state = Faker::Address.state_abbr
          email = Faker::Internet.email
          telephone = Faker::PhoneNumber.phone_number
          Customer.create(
            fullname: fullname,
            address: address,
            city: city,
            state: state,
            email: email,
            telephone: telephone,
            account_number: account_number,
            balance: 0.00
          )
        end
        render json: { message: 'Account numbers generated successfully' }
    end
end 