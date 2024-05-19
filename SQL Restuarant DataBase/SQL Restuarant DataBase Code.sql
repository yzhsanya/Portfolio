
DROP TABLE IF EXISTS RestaurantRating;
DROP TABLE IF EXISTS RestaurantAddress;
DROP TABLE IF EXISTS AddressTable;
DROP TABLE IF EXISTS ItemsForOrder;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS ItemCategory;
DROP TABLE IF EXISTS OrderTable;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS CustomerDetails;
DROP TABLE IF EXISTS Restaurant;
DROP TABLE IF EXISTS DeliverInfo;
DROP TABLE IF EXISTS Supplier;

 CREATE TABLE Supplier (
  SupplierID     INT NOT NULL ,
  SupplierName   VARCHAR(255) NOT NULL,
  SupplierTelNum VARCHAR(255) NOT NULL,
  CONSTRAINT PK_Supplier_SupplierID PRIMARY KEY (SupplierID)
)

CREATE TABLE DeliverInfo (
  DeliverID          INT NOT NULL ,
  DeliverTelNum      VARCHAR(255) ,
  DeliverCarNumber   VARCHAR(15) ,
  CONSTRAINT PK_DeliverInfo_DeliverID PRIMARY KEY (DeliverID)
)

CREATE TABLE Restaurant (
  RestaurantID            INT NOT NULL ,
  RestaurantName          VARCHAR(255) ,
  RestaurantTelNum        VARCHAR(20),
  RestaurantEmail         VARCHAR(255),
  RestaurantDescription   VARCHAR(255),
  CONSTRAINT PK_Restaurant PRIMARY KEY (RestaurantID)
)

CREATE TABLE CustomerDetails (
  CustomerDetailsID   INT NOT NULL ,
  Name                VARCHAR(255) ,
  Surname             VARCHAR(255) ,
  Email               VARCHAR(255) ,
  TelNum              VARCHAR(20) ,
  FirstLine           VARCHAR(255) ,
  PostCode            VARCHAR(7) ,
  City                VARCHAR(255),
  CONSTRAINT  PK_CustomerDetails_CustomerDetailsID PRIMARY KEY (CustomerDetailsID)
)

CREATE TABLE Customer (
  CustomerID         INT NOT NULL,
  CustomerDetailsID  INT NOT NULL ,
  CONSTRAINT PK_Customer_CustomerID PRIMARY KEY (CustomerID),
  CONSTRAINT FK_Customer_CustomerDetails FOREIGN KEY (CustomerDetailsID)  REFERENCES CustomerDetails(CustomerDetailsID)
)

CREATE TABLE OrderTable (
  OrderID           INT NOT NULL ,
  OrderDate         DATETIME ,
  CustomerID        INT NOT NULL ,
  RestaurantID      INT NOT NULL ,
  DeliverID         INT NOT NULL ,
  CONSTRAINT PK_Order_OrderID PRIMARY KEY (OrderID),
  CONSTRAINT FK_Order_DeliverInfo_DeliverID FOREIGN KEY (DeliverID) REFERENCES DeliverInfo(DeliverID),
  CONSTRAINT FK_Order_Restaurant_RestaurantID FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID),
  CONSTRAINT FK_Order_Customer_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
)

CREATE TABLE ItemCategory (
  ItemCategoryID INT NOT NULL ,
  ItemType       VARCHAR(255),
  ItemCategory   VARCHAR(255),
  CONSTRAINT PK_ItemCategory_ItemCategoryID PRIMARY KEY (ItemCategoryID)
)

CREATE TABLE Item (
  ItemID           INT NOT NULL ,
  ItemName         VARCHAR(255) ,
  ItemDescription  VARCHAR(255),
  ItemCategoryID   INT NOT NULL ,
  ItemPrice        FLOAT,
  Vegan            BIT,
  Vegetarian       BIT,
  GlutenFree       BIT,
  ContainsNuts     BIT,
  Allergies        VARCHAR(255),
  SupplierID       INT NOT NULL,
  CONSTRAINT PK_Item_ItemID PRIMARY KEY (ItemID),
  CONSTRAINT FK_Item_ItemCategory_ItemCategoryID FOREIGN KEY (ItemCategoryID) REFERENCES ItemCategory(ItemCategoryID),
  CONSTRAINT FK_Item_Supplier_SupplierID FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
)

CREATE TABLE ItemsForOrder (
  OrderID        INT NOT NULL,
  ItemID         INT NOT NULL,
  Adjustments    VARCHAR(255),
  ItemQuantity   INT,
  CONSTRAINT PK_ItemsForOrder PRIMARY KEY (OrderID, ItemID),
  CONSTRAINT FK_ItemsForOrder_OrderID FOREIGN KEY (OrderID) REFERENCES OrderTable(OrderID),
  CONSTRAINT FK_ItemsForOrder_Item_ItemID FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
)

CREATE TABLE AddressTable (
  RestaurantAddressID    INT NOT NULL,
  FirstLine              VARCHAR(255),
  Postcode               VARCHAR(20),
  City                   VARCHAR(255),
  County                 VARCHAR(255),
  Country                VARCHAR(255),
  CONSTRAINT PK_AddressTable_RestaurantAddressID PRIMARY KEY (RestaurantAddressID)
)

CREATE TABLE RestaurantAddress (
  RestaurantAddressID    INT NOT NULL ,
  RestaurantID           INT NOT NULL ,
  CONSTRAINT PK_RestaurantAddress PRIMARY KEY (RestaurantAddressID,RestaurantID),
  CONSTRAINT FK_Restaurant_RestaurantID FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID),
  CONSTRAINT FK_Restaurant_RestaurantAddressID FOREIGN KEY (RestaurantAddressID) REFERENCES AddressTable(RestaurantAddressID)

)

CREATE TABLE RestaurantRating (
  ReviewID        INT NOT NULL,
  CustomerID      INT NOT NULL,
  Review          VARCHAR(255),
  Rating          VARCHAR(255),
  RestaurantID    INT NOT NULL,
  CONSTRAINT PK_RestaurantRating PRIMARY KEY (ReviewID),
  CONSTRAINT FK_RestaurantRating_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  CONSTRAINT FK_RestaurantRating_RestaurantID FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
)




INSERT INTO Supplier(SupplierID, SupplierName, SupplierTelNum)
VALUES(1,'Butchers','05112504305'),
      (2,'JonnyS Foods','0124014010'),
      (3,'FreshVeg','01405140350')


INSERT INTO DeliverInfo(DeliverID, DeliverTelNum, DeliverCarNumber)
VALUES (1,'0216020645','JS00FJF'),
       (2,'010532010','KL12FYF'),
       (3,'013051033','FK98HGF')


INSERT INTO Restaurant(RestaurantID, RestaurantName, RestaurantTelNum, RestaurantEmail,RestaurantDescription)
VALUES (1,'Tropical Island Desserts','012443542234','Tropical.Islands@DragonFruit.com','Specialises is fruity desserts and drinks'),
       (2,'Cheesy Cheeseria','01513390232','Cheesy.Cheese@Rockfort.co.uk','The cheesiest eating place in town'),
       (3,'Carrot Top','01513542341','Carrot.Top@Vegg.com','Specialist vegetarian restaurant for all your veggie needs')


INSERT INTO CustomerDetails(CustomerDetailsID, Name, Surname, Email, TelNum, FirstLine, PostCode, City)
VALUES (1,'Eric','Wimp','BananaMad@Dandy.com','07845263374','29 Acacia road','NH67PK','Nutty town'),
       (2,'William ','Benn','MrBenn@fancydress.com','07326629551','52 Festive road','LO89OP','London'),
       (3,'Dougal','Dog','Dougal@Magic.com','05638384938','36 Magic Garden','MG01HJ','Magic Roundabout')


INSERT INTO Customer(CustomerID, CustomerDetailsID)
VALUES (1,1),
       (2,2),
       (3,3)


INSERT INTO OrderTable(OrderID, OrderDate, CustomerID, RestaurantID, DeliverID)
VALUES (1,'2023-11-11 14:23:12',1,1,1),
       (2,'2023-11-11 16:47:31',2,2,2),
       (3,'2023-11-11 19:10:51',3,3,3)


INSERT INTO ItemCategory(ItemCategoryID, ItemType,ItemCategory)
VALUES (1,'vegetarian/vegan','desert'),
       (2,'vegetarian/vegan salad','main'),
       (3,'vegetarian kebab','starter'),
       (4,'vegetarian pizza','main'),
       (5,'','main'),
       (6,'','desert'),
       (7,'vegan raw food','main'),
       (8,'vegetarian burger', 'main'),
       (9,'vegetarian,chefs specials','main')


INSERT INTO Item(ItemID, ItemName, ItemDescription, ItemCategoryID, ItemPrice, Vegan, Vegetarian, GlutenFree, ContainsNuts, SupplierID)
VALUES (1,'Banana Special','3 banana dessert covered in vanilla ice cream',1,2.99,1,1,0,0,2),
       (2,'Three fruit salad','A fruit salad containing kiwis,bananas and melons',2,4.99,1,1,0,0,2),
       (3,'Fruit and Cheese Skewer','Strawberries and grapes interleaved with cheddar cheese on a stick',3,1.99,0,1,0,0,2),
       (4,'Cheesey Margherita Pizza','Three cheese pizza with a tangy tomato sauce',4,5.99,0,1,0,0,1),
       (5,'Mozzarella Lasagne','Super strechy mozzarella lasagne',5,6.99,0,0,0,0,1),
       (6,'Cheese board','Selection of cheeses for the cheesiest cheese enthusiasts',6,3.99,0,0,0,0,1),
       (7,'Rabbit Food Special','Medley of raw carrots,cabbage,and turnips',7,4.99,1,0,0,0,3),
       (8,'Herbivorous Burger','Plant based meat alternative with lettuce,cheese,and chunky chips',8,5.99,0,1,0,0,3),
       (9,'Courgette frittata','Courgette, spring onions and goat cheese',9,4.99,0,1,0,0,3)


INSERT INTO  ItemsForOrder(OrderID, ItemID, Adjustments, ItemQuantity)
VALUES (1,1,'extra banana',1),
       (2,4,'',1),
       (2,6,'no cheddar',1),
       (3,7,'',1),
       (3,9,'extra onions',1)


INSERT INTO AddressTable (RestaurantAddressID, FirstLine, Postcode, City,County,Country)
VALUES (1,'10 Fruit street','CH56HG','Durian','Cheshire','UK'),
       (2,'45 Brie avenue','MS78UK','Stilton','Merseyside','UK'),
       (3,'626 Legume road','1050','Brussels','','Belgium')


INSERT INTO RestaurantAddress(RestaurantAddressID, RestaurantID)
VALUES (1,1),
       (2,2),
       (3,3)


INSERT INTO RestaurantRating(ReviewID, CustomerID, Review, Rating, RestaurantID)
VALUES (1,1,'Good Restaurant','5,0 stars',1),
       (2,1,'Food was cold','3,4 stars',2),
       (3,2,'Well done!','5,0 stars',2),
       (4,3,'I did enjoy it','4,0',3)

