class Invoice < ActiveRecord::Base
  include Canable::Ables
  
  validates_presence_of :project_id, :message => "- Please choose a project"
	belongs_to :project
	
  validates_presence_of :start_date, :end_date
	
	def total_cost
		sum = 0
		self.iftask.each do |task|
		  self.date_cost2[task.id].each do |cost|
		    sum = sum + cost.get_cost
		  end
		end
		return sum
	end
	
	#doesnt work
	def task_cost(id)
		sum = 0
		self.date_cost2[id].each do |cost|
		    sum = sum + cost.get_cost
		end
		return sum
	end
	
	def date_cost2
	    mycosts = Array.new
		self.project.tasks.each do |task|
		  mycosts2 = task.project_costs.find(:all, :conditions => {:date => start_date..end_date, :state => [ProjectCost::Approved] })
		  #if mycosts2.empty? then
		   # next
		  #end
		  mycosts[task.id] = mycosts2
		end
		return mycosts
	end
	
	def iftask
	    mytasks = Array.new
		self.project.tasks.each do |task|
		  mycosts2 = Array.new
          mycosts2.concat(task.project_costs.find(:all, :conditions => {:date => start_date..end_date, :state => [ProjectCost::Approved] }))
	      if mycosts2.empty?
		    next
		  end
		  mytasks << task
		end
		return mytasks
	end
	
#	def updateInv		
#		self.iftask.each do |task|
#		  self.date_cost2[task.id].each { |y| y.state = ProjectCost::Invoiced 
#  		    y.save! }
#		end
#	end
	
end


#         def date_cost
#	    mycosts = Array.new
#		self.project.tasks.each do |task|
#          mycosts.concat(task.project_costs.find(:all, :conditions => {:date => start_date..end_date }))
#		end
#		return mycosts
#	end
