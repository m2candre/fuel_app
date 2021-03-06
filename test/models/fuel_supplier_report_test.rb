require 'test_helper'

class FuelSupplierReportTest < ActiveSupport::TestCase
  def setup
    @one = fuel_supplier_reports :one
  end

  test 'responds to fuel_card_brand, start_date, end_date' do
    assert @one.respond_to? :fuel_card_brand
    assert @one.respond_to? :start_date
    assert @one.respond_to? :end_date
  end

  # Associations.

  test 'should belong to fuel card brand' do
    refl = FuelSupplierReport.reflect_on_association :fuel_card_brand
    assert_not_nil refl
    assert_equal refl.macro, :belongs_to
    assert_equal refl.options, {}
  end

  test 'should have zero or more checks' do
    refl = FuelSupplierReport.reflect_on_association :checks
    assert_not_nil refl
    assert_equal refl.macro, :has_many
    assert_equal refl.options, {}
  end

  # Validations.

  test 'should be valid' do
    assert @one.valid?
  end

  test 'fuel card brand should be present' do
    @one.fuel_card_brand = nil
    assert @one.invalid?
    assert_includes @one.errors[:fuel_card_brand], 'must exist'
  end

  test 'start date should not be in the future' do
    @one.start_date = Date.tomorrow
    assert @one.invalid?
    assert_includes @one.errors[:start_date], "can't be in the future"
  end 

  test 'end date should not be in the future' do
    @one.end_date = Date.tomorrow
    assert @one.invalid?
    assert_includes @one.errors[:end_date], "can't be in the future"
  end

  test 'end date should be before or equal to start date' do
    @one.end_date = @one.start_date.yesterday
    assert @one.invalid?
    assert_includes @one.errors[:end_date],
      "must be after or equal to start date"
  end
end
