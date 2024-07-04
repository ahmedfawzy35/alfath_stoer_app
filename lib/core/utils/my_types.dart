// ignore_for_file: constant_identifier_names

enum OrdersTyps { Order, OrderBack, Purchase, PurchaseBack }

class CustomerAccountElementTyps {
  static const String Order = 'Order';
  static const String OrderBack = 'OrderBack';
  static const String CashInFromCustomer = 'CashInFromCustomer';
  static const String CustomerAddingSettlement = 'CustomerAddingSettlement';
  static const String CustomerDiscountSettlement = 'CustomerDiscountSettlement';
}

class SellerAccountElementTyps {
  static const String Purchase = 'Purchase';
  static const String PurchaseBack = 'PurchaseBack';
  static const String CashOutToSeller = 'CashOutToSeller';
  static const String SellerAddingSettlement = 'SellerAddingSettlement';
  static const String SellerDiscountSettlement = 'SellerDiscountSettlement';
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
  