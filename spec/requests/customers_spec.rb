# spec/controllers/customers_controller_spec.rb
require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  describe "GET #check_balance" do
    it "returns http success" do
      customer = Customer.create(account_number: '203074880043562', balance: 100.00)
      get :check_balance, params: { account_number: customer.account_number }
      expect(response).to have_http_status(:success)
    end

    it "returns the balance of the customer" do
      customer = Customer.create(account_number: '203074880043562', balance: 100.00)
      get :check_balance, params: { account_number: customer.account_number }
      expect(JSON.parse(response.body)['balance']).to eq(100.00)
    end
  end

  describe "POST #transfer_money" do
    it "transfers money successfully" do
      sender = Customer.create(account_number: '203074880043562', balance: 100.00)
      receiver = Customer.create(account_number: '203074880043563', balance: 0.00)
      post :transfer_money, params: { sender_account_number: sender.account_number, receiver_account_number: receiver.account_number, amount: 50.00 }
      expect(response).to have_http_status(:success)
      expect(sender.reload.balance).to eq(50.00)
      expect(receiver.reload.balance).to eq(50.00)
    end

    it "returns unprocessable entity if sender has insufficient balance" do
      sender = Customer.create(account_number: '203074880043562', balance: 20.00)
      receiver = Customer.create(account_number: '203074880043563', balance: 0.00)
      post :transfer_money, params: { sender_account_number: sender.account_number, receiver_account_number: receiver.account_number, amount: 50.00 }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(sender.reload.balance).to eq(20.00)
      expect(receiver.reload.balance).to eq(0.00)
    end
  end

  describe "PUT #update_balance" do
    it "updates the balance of the customer" do
      customer = Customer.create(account_number: '203074880043562', balance: 100.00)
      put :update_balance, params: { account_number: customer.account_number, balance: 150.00 }
      expect(response).to have_http_status(:success)
      expect(customer.reload.balance).to eq(150.00)
    end

    it "returns not found if customer does not exist" do
      put :update_balance, params: { account_number: 'invalid_account_number', balance: 100.00 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #generate_account_numbers" do
    it "generates 10 account numbers" do
      expect {
        post :generate_account_numbers
      }.to change(Customer, :count).by(10)
      expect(response).to have_http_status(:success)
    end
  end
end
