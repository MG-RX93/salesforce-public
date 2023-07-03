global class ScheduleCaseUpdates implements Schedulable {
	global void execute(SchedulableContext sc) {
		this.updateCases();
	}

	private void updateCases() {
		List<Case> caseUpdateList = new List<Case>();
		List<Case> caseList = [SELECT Id, Status, Description FROM Case];
		for (Case c : caseList) {
			switch on c.Status {
				when 'Closed' {
					c.Status = 'New';
					c.Description = 'Reopened Case';
				}
				when 'New' {
					c.Status = 'Working';
					c.Description = 'Updated to Working';
				}
				when 'Working' {
					c.Status = 'Escalated';
					c.Description = 'Case is now Escalated';
				}
				when 'Escalated' {
					c.Status = 'Closed';
					c.Description = 'Case is now Closed';
				}
			}
			caseUpdateList.add(c);
		}
		update caseUpdateList;
	}
}