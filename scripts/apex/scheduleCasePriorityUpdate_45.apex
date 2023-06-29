ScheduleCasePriorityUpdate scpu = new ScheduleCasePriorityUpdate();
String sch = '0 45 * * * ?';
System.schedule('Schedule Case Priority Update 45', sch, scpu);