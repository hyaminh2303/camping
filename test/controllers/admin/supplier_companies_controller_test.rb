require "test_helper"

class Admin::SupplierCompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @supplier_company = admin_supplier_companies(:one)
  end

  test "should get index" do
    get admin_supplier_companies_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_supplier_company_url
    assert_response :success
  end

  test "should create admin_supplier_company" do
    assert_difference('Admin::SupplierCompany.count') do
      post admin_supplier_companies_url, params: { admin_supplier_company: { company_name: @supplier_company.company_name, corporate_category: @supplier_company.corporate_category, corporate_name_kana: @supplier_company.corporate_name_kana, fax: @supplier_company.fax, hp_url: @supplier_company.hp_url, location: @supplier_company.location, operation_classification: @supplier_company.operation_classification, phone_number: @supplier_company.phone_number, ryokan: @supplier_company.ryokan } }
    end

    assert_redirected_to admin_supplier_company_url(Admin::SupplierCompany.last)
  end

  test "should show admin_supplier_company" do
    get admin_supplier_company_url(@supplier_company)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_supplier_company_url(@supplier_company)
    assert_response :success
  end

  test "should update admin_supplier_company" do
    patch admin_supplier_company_url(@supplier_company), params: { admin_supplier_company: { company_name: @supplier_company.company_name, corporate_category: @supplier_company.corporate_category, corporate_name_kana: @supplier_company.corporate_name_kana, fax: @supplier_company.fax, hp_url: @supplier_company.hp_url, location: @supplier_company.location, operation_classification: @supplier_company.operation_classification, phone_number: @supplier_company.phone_number, ryokan: @supplier_company.ryokan } }
    assert_redirected_to admin_supplier_company_url(@supplier_company)
  end

  test "should destroy admin_supplier_company" do
    assert_difference('Admin::SupplierCompany.count', -1) do
      delete admin_supplier_company_url(@supplier_company)
    end

    assert_redirected_to admin_supplier_companies_url
  end
end
