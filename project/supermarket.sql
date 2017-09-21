-- 创建超市库
CREATE DATABASE  supermarket;
USE supermarket;
-- 创建表
-- 创建员工表
DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
 eid INT AUTO_INCREMENT COMMENT "表主键id" ,
 NAME VARCHAR(20) NOT NULL COMMENT "员工姓名",
 account VARCHAR(20) NOT NULL COMMENT  "员工登录系统帐号",
 pwd VARCHAR(50)  NOT NULL COMMENT "登录密码",
 state CHAR(4)  DEFAULT '正常' COMMENT "帐号状态",
 job VARCHAR(10) DEFAULT '收银员' COMMENT "员工职位",
 PRIMARY KEY (eid)
) ;
-- 创建商品表
DROP TABLE IF EXISTS goods;
CREATE TABLE  goods(
gid INT AUTO_INCREMENT COMMENT '表主键id',
NAME VARCHAR(20) NOT NULL COMMENT '商品名字',
price DOUBLE(5,2) NOT NULL COMMENT '商品价格',
activity DOUBLE(2,1)  COMMENT '折扣',
PRIMARY KEY (gid),
INDEX index_name (NAME)
);
-- 创建会员表
DROP TABLE IF EXISTS member;
CREATE TABLE member(
meid INT AUTO_INCREMENT COMMENT '会员id',
NAME VARCHAR(20) NOT NULL COMMENT '会员名字',
num VARCHAR(20) NOT NULL COMMENT '会员帐号',
phone CHAR(20) NOT NULL  COMMENT '会员电话',
intagral INT DEFAULT 0 COMMENT '积分',
PRIMARY KEY (meid)
) ;
ALTER TABLE member ADD  UNIQUE (phone);
-- 创建公司账务表
DROP TABLE IF EXISTS finance;
CREATE TABLE finance (
fid  INT NOT NULL ,
NAME VARCHAR(20) NOT NULL COMMENT '公司名称',
total DOUBLE(20,2) COMMENT '公司总收入',
PRIMARY KEY (fid)
);

-- 创建操作流水表
DROP TABLE superlog;
CREATE TABLE superlog(
lid INT AUTO_INCREMENT COMMENT '主键id',
number VARCHAR(100) UNIQUE COMMENT '流水号',
emid INT COMMENT '哪个员工操作产生的日志',
meid INT COMMENT '会员产生的日志',
opt  VARCHAR(20) COMMENT '操作',
opt_time DATETIME COMMENT '操作日期',
money DOUBLE COMMENT '本次消费的金额',
PRIMARY KEY (lid)
);
ALTER TABLE superlog ADD CONSTRAINT  fk_employee_superlog FOREIGN KEY (emid) REFERENCES  employee (eid);
ALTER TABLE superlog ADD CONSTRAINT `fk_member_superlog` FOREIGN KEY (`meid`) REFERENCES `member` (`meid`);
ALTER TABLE superlog DROP FOREIGN KEY fk_member_superlog ;
-- 给superlog添加一个触发器 当插入数据后，就将流水金额加入到公司总账户里
DELIMITER @
CREATE TRIGGER tri_inser AFTER INSERT ON superlog
FOR EACH ROW
BEGIN
  UPDATE finance SET tatal=total+new.money WHERE NAME='自学小组超市';
END@
-- 给superlog 添加一个触发器 当修改了数据后，将流水的钱数改变，把以前的旧的钱数在总帐号删除 然后在新的钱数增加
DELIMITER @
CREATE TRIGGER tri_upd AFTER UPDATE ON superlog
FOR EACH ROW
BEGIN
  UPDATE finance SET tatal=total-old.money+new.money WHERE NAME='自学小组超市';
END@

SHOW CREATE TABLE superlog;

-- 创建操作流水表和商品列表的对应关系  当此流水中都购买了哪些物品
DROP TABLE log_goods;
CREATE TABLE  log_goods(
number_log VARCHAR(100),
gid INT,
CONSTRAINT fk_log_goods_number FOREIGN KEY (number_log) REFERENCES superlog (number),
CONSTRAINT fk_log_goods_gid  FOREIGN KEY (gid) REFERENCES  goods(gid)
);
 
-- 造数据
INSERT INTO  finance VALUES (1,'自学小组超市',0);
INSERT INTO employee VALUES (DEFAULT,'李康','likang',MD5('likang'),DEFAULT,DEFAULT);
INSERT INTO employee VALUES (DEFAULT,'风萧萧','fxx',MD5('fxx'),DEFAULT,'售后'),(DEFAULT,'徐浩浩','xhh',MD5('xhh'),DEFAULT,DEFAULT),(DEFAULT,'金鑫鑫','jxx',MD5('jxx'),DEFAULT,DEFAULT);
INSERT INTO goods VALUES (DEFAULT,'青岛啤酒',4.5,0),(DEFAULT,'可口可乐',3,0),(DEFAULT,'西红柿',1,0),(DEFAULT,'短袖',49.9,0)
,(DEFAULT,'袜子',10,0),(DEFAULT,'双汇火腿',9.6,0),(DEFAULT,'安慕希酸奶',6.5,0),(DEFAULT,'西凤酒10年',299,0),
(DEFAULT,'西瓜',10,0),(DEFAULT,'泰国香米',188,0),(DEFAULT,'鲁花菜籽油',99,0),(DEFAULT,'喜之郎果冻',5.5,0);
INSERT INTO member VALUES (DEFAULT,'likang','12345','1367231312',DEFAULT);
INSERT INTO superlog VALUES (DEFAULT,'12132355',2,NULL,'结账',NOW(),'213');
SELECT * FROM employee;
SELECT * FROM goods;
SELECT * FROM employee WHERE account=? AND pwd=?

SELECT * FROM 