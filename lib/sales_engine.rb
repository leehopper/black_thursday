require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'
require_relative 'customer_repository'
require_relative 'sales_analyst'
require 'csv'

class SalesEngine
  attr_reader :items, :merchants, :invoices, :invoice_items, :transactions, :customers
  def initialize(path)
    @items = ItemRepository.new(path[:items])
    @merchants = MerchantRepository.new(path[:merchants])
    @invoices = InvoiceRepository.new(path[:invoices])
    @invoice_items = InvoiceItemRepository.new(path[:invoice_items])
    @transactions = TransactionRepository.new(path[:transactions])
    @customers = CustomerRepository.new(path[:customers])
  end

  def self.from_csv(path)
    new(path)
  end

  def analyst
    SalesAnalyst.new(self)
  end

  def item_repo_group_items_by_merchant
    @items.group_items_by_merchant
  end

  def item_repo_items_per_merchant
    @items.items_per_merchant
  end

  def item_repo_total_merchants
    @items.number_of_merchants
  end

  def item_repo_total_items
    @items.total_items
  end

  def item_repo_total_items_by_merchant(merchant_id)
    @items.total_items_by_merchant(merchant_id)
  end

  def item_repo_merchant_price_sum(merchant_id)
    @items.merchant_price_sum(merchant_id)
  end

  def item_repo_total_item_price
    @items.items_total_price
  end

  def item_repo_all_items_by_price
    @items.all_items_by_price
  end

  def item_repo_all_items
    @items.all
  end

  def merchant_repo_find_by_id(id)
    @merchants.find_by_id(id)
  end

  def invoice_repo_group_by_merchant
    @invoices.group_invoices_by_merchant
  end

  def invoice_repo_invoices_per_merchant
    @invoices.invoices_per_merchant
  end

  def invoice_repo_total_merchants
    @invoices.number_of_merchants
  end

  def invoice_repo_total_invoices
    @invoices.total_invoices
  end

  def invoice_repo_invoices_per_day
    @invoices.invoices_per_day
  end

  def invoice_repo_invoices_day_created_date
    @invoices.invoices_by_created_date
  end

  def invoice_repo_by_status(status)
    @invoices.invoice_status_total(status)
  end

  def tranaction_repo_invoice_paid_in_full(invoice_id)
    @transactions.invoice_paid_in_full(invoice_id)
  end

  def invoice_items_repo_invoice_total_by_id(invoice_id)
    @invoice_items.invoice_total_by_id(invoice_id)
  end

  def pending_transaction_merchant_ids
    new_array = []
    @transactions.pending_transactions_invoice_ids.each do |invoice|
      new_array << @invoices.find_by_id(invoice)
    end
    new_array
  end

end
