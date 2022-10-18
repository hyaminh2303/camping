require "application_system_test_case"

class Admin::SupplierCompaniesTest < ApplicationSystemTestCase
  setup do
    @supplier_company = admin_supplier_companies(:one)
  end

  test "visiting the index" do
    visit admin_supplier_companies_url
    assert_selector "h1", text: "Admin/Supplier Companies"
  end

  test "creating a Supplier company" do
    visit admin_supplier_companies_url
    click_on "New Admin/Supplier Company"

    fill_in "Company name", with: @supplier_company.company_name
    fill_in "Corporate category", with: @supplier_company.corporate_category
    fill_in "Corporate name kana", with: @supplier_company.corporate_name_kana
    fill_in "Fax", with: @supplier_company.fax
    fill_in "Hp url", with: @supplier_company.hp_url
    fill_in "Location", with: @supplier_company.location
    fill_in "Operation classification", with: @supplier_company.operation_classification
    fill_in "Phone number", with: @supplier_company.phone_number
    fill_in "Ryokan", with: @supplier_company.ryokan
    click_on "Create Supplier company"

    assert_text "Supplier company was successfully created"
    click_on "Back"
  end

  test "updating a Supplier company" do
    visit admin_supplier_companies_url
    click_on "Edit", match: :first

    fill_in "Company name", with: @supplier_company.company_name
    fill_in "Corporate category", with: @supplier_company.corporate_category
    fill_in "Corporate name kana", with: @supplier_company.corporate_name_kana
    fill_in "Fax", with: @supplier_company.fax
    fill_in "Hp url", with: @supplier_company.hp_url
    fill_in "Location", with: @supplier_company.location
    fill_in "Operation classification", with: @supplier_company.operation_classification
    fill_in "Phone number", with: @supplier_company.phone_number
    fill_in "Ryokan", with: @supplier_company.ryokan
    click_on "Update Supplier company"

    assert_text "Supplier company was successfully updated"
    click_on "Back"
  end

  test "destroying a Supplier company" do
    visit admin_supplier_companies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Supplier company was successfully destroyed"
  end
end
