module SupplierCompanyAsTenant
  extend ActiveSupport::Concern

  included do
    belongs_to :supplier_company
    acts_as_tenant :supplier_company
    validates_presence_of :supplier_company

    # override method the avoid error "ActsAsTenant::Errors::TenantIsImmutable"
    define_method "#{ActsAsTenant.fkey}=" do |integer|
      write_attribute(ActsAsTenant.fkey.to_s, integer)
      integer
    end

    define_method "#{ActsAsTenant.tenant_klass}=" do |model|
      super(model)
      model
    end
  end
end
