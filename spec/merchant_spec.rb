require_relative 'spec_helper'
require_relative '../lib/merchant'
require_relative '../lib/merchant_repository'
require 'csv'

RSpec.describe do
  before(:each) do
    @data = {id: 5, name: 'Turing'}
    # @repo = double('repo')
    @repo = MerchantRepository.new('./spec/fixtures/mock_merchants.csv')
    @merchant = Merchant.new(@data, @repo)
  end
  it 'exists' do
    expect(@merchant).to be_a Merchant
  end

  it 'has attributes' do
    expect(@merchant.id).to eq(5)
    expect(@merchant.name).to eq('Turing')
  end

  xit 'can create new merchants' do
    # allow(@merchant).to receive(:repo.next_highest_merchant_id).and_return(6)
    allow(@repo).to receive(:next_highest_merchant_id).and_return(6)
    expect(Merchant.create_merchant({name: 'Marla'})).to be_a(Merchant)
  end

  it 'can update old merchants' do
    @merchant.update_merchant(5, {name: 'New Turing'})
    expect(@merchant.id).to eq(5)
    expect(@merchant.name).to eq('New Turing')
  end

end
