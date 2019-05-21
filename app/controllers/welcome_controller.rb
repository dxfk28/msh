# Redmine - project management software
# Copyright (C) 2006-2017  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class WelcomeController < ApplicationController
  self.main_menu = false

  def index
    @news = News.latest User.current
  end

  def robots
    @projects = Project.all_public.active
    render :layout => false, :content_type => 'text/plain'
  end

  def msh
  	# render :layout => false
  end

  def yue_biao
    @issue = Issue.find_by(id:params[:issue_id])
    @time = Time.now().strftime("%Y")
    @year = Time.now().year
    @yue = [1,2,3,4,5,6,7,8,9,10,11,12]
    @ke = ["麻醉科","疼痛科","手术室","康复科","骨科","风湿科","超声科","体检科","干部病房",
      "急诊科","ICU","重症病房","甲乳科","泌尿科","介入科","肿瘤科","神经内科","神经外科","肝胆外科","妇产科","胰腺科",
      "呼吸科","消化科","血管外科","透析科","儿科","心内科","心外科","内分泌科","普外科","中医科"]
    @count = []
    @yue.each do |yue|
      # binding.pry
      count = @issue.place_records.where("created_at > ? and created_at < ?",Time.new(@year,yue,1),Time.new(@year,yue,31)).count
      # binding.pry
      # count = format("%.2f",count/Setting[:turnover_base].to_f*100) 
      count = count/Setting[:turnover_base].to_f*100
      # @count << helper.number_to_percentage(count/Setting[:turnover_base].to_f, precision: 2).to_f
      @count << count
    end
  end

  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end

end
