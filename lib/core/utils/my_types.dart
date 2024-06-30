enum OrdersTyps { Order, OrderBack, Purchase, PurchaseBack }

enum CustomerAccountElementTyps {
  Order,
  OrderBack,
  CashInFromCustomer,
  CustomerAddingSettlement,
  CustomerDiscountSettlement
}

enum SellerAccountElementTyps {
  Purchase,
  PurchaseBack,
  CashOutToSeller,
  SellerAddingSettlement,
  SellerDiscountSettlement
}

enum EmployeeSalaryElemntTypes {
  EmployeeLesses,
  EmployeeIncreases,
  CashOutToAdvancepaymentOfSalaries,
  CashOutToSalaries,
  EmployeePenalties,
  EmployeeReward,
}

enum EmployeeProcessTypes {
  EmployeeLesses,
  EmployeeIncreases,
  AbsenceFromWork,
  EmployeePenalties,
  EmployeeReward,
}

enum CashItemTyps {
  Order,
  OrderBack,
  Purchase,
  PurshaseBack,
  cashInFromBankAccount,
  cashInFromCustomer,
  cashInFromIncome,
  cashInFromMasterMoneySafe,
  cashInFromBrancheMoneySafe,
  cashOutToAdvancepaymentOfSalary,
  cashOutToBankAccount,
  cashOutToMasterMoneySafe,
  cashOutToBrancheMoneySafe,
  cashOutToOutGoing,
  cashOutToSalary,
  cashOutToSeller,
}

enum CashInTyps {
  cashInFromBankAccount,
  cashInFromCustomer,
  cashInFromIncome,
  cashInFromMasterMoneySafe,
  cashInFromBrancheMoneySafe,
}

enum CashOutTyps {
  cashOutToAdvancepaymentOfSalary,
  cashOutToBankAccount,
  cashOutToMasterMoneySafe,
  cashOutToOutGoing,
  cashOutToSalary,
  cashOutToSeller,
  cashOutToBrancheMoneySafe,
}

enum CashModelTyps {
  cashInFromBankAccount,
  cashInFromCustomer,
  cashInFromIncome,
  cashInFromMasterMoneySafe,
  cashInFromBrancheMoneySafe,
  cashOutToAdvancepaymentOfSalary,
  cashOutToBankAccount,
  cashOutToMasterMoneySafe,
  cashOutToOutGoing,
  cashOutToSalary,
  cashOutToSeller,
  cashOutToBrancheMoneySafe,
}

enum PermissionsType {
  View,
  Create,
  Edit,
  Delete,
}
      //public enum ModelType
      //{
      //    Order,
      //    OrderDetail,
      //    OrderBack,
      //    OrderBackDetail,
      //    Purchase,
      //    PurchaseDetail,
      //    PurchaseBack,
      //    PurchaseBackDetail,
      //    CashInFromCustomer,
      //    CustomerAddingSettlement,
      //    CustomerDiscountSettlement,
      //    SellerAddingSettlement,
      //    SellerDiscountSettlement,
      //    EmployeeLesses,
      //    EmployeeIncreases,
      //    CashOutToAdvancepaymentOfSalaries,
      //    CashOutToSalaries,
      //    EmployeePenalties,
      //    EmployeeReward,
      //    cashInFromBankAccount,
      //    cashInFromIncome,
      //    cashInFromMasterMoneySafe,
      //    cashInFromBrancheMoneySafe,
      //    cashOutToAdvancepaymentOfSalary,
      //    cashOutToBankAccount,
      //    cashOutToMasterMoneySafe,
      //    cashOutToBrancheMoneySafe,
      //    cashOutToOutGoing,
      //    cashOutToSalary,
      //    CashOutToSeller,
      //    BankAccount,
      //    Branche,
      //    BrancheMoneySafe,
      //    CashDayClose,
      //    Catogry,
      //    Product,
      //    Customer,
      //    Employee,
      //    InCome,
      //    MasterMoneySafe,
      //    Role,
      //    Seller,
      //    User,

      //}
  