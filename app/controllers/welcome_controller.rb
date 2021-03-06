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

  def region
    @year = Time.now().year
    @yue = Time.now().month
    @count = []
    place_records = PlaceRecord.where("created_at > ? and created_at < ? and category = ? ",Time.new(@year,@yue,1),Time.new(@year,@yue,31),"本体")
    all_count = place_records.count
    @users = User.where(id:Issue.pluck(:assigned_to_id).uniq).order("lastname desc")
    @users.each do |user|
      count = place_records.where(province:CustomValue.where(customized_type:"Principal",customized_id:user.id,custom_field_id:22).pluck(:value)).count
      count = count/all_count.to_f*100
      count = format("%.2f",count).to_f
      @count << count
    end
  end

  def region_html
    if params[:time].present?
      @year = params[:time].split("-")[0]
      @yue = params[:time].split("-")[1]
    else
      @year = Time.now().year
      @yue = Time.now().month
    end
    @count = []
    place_records = PlaceRecord.where("created_at > ? and created_at < ? and category = ? ",Time.new(@year,@yue,1),Time.new(@year,@yue,31),"本体")
    all_count = place_records.count
    @users = User.where(id:Issue.pluck(:assigned_to_id).uniq).order("lastname desc")
    @users.each do |user|
      count = place_records.where(province:CustomValue.where(customized_type:"Principal",customized_id:user.id,custom_field_id:22).pluck(:value)).count
      count = count/all_count.to_f*100
      count = format("%.2f",count).to_f
      @count << count
     end
    render :partial => 'region', :layout => false
  end

  def msh
    @time = Time.now().to_date.to_s if params[:time].blank?
    @year = Time.now().year
    @yue = Time.now().month
    @ke = CustomField.find_by(id:29).possible_values.delete_if { |item| item=="-" }
    @lei = CustomField.where(id:(31..35)).pluck(:name)
    @count = []
    if params[:province].blank?
      @province = "辽宁"
    else
      @province = params[:province]
    end
    all_count = PlaceRecord.where("created_at > ? and created_at < ? and province = ? and department in (?) and category = ? ",Time.new(@year,@yue,1),Time.new(@year,@yue,31),@province,@ke,"本体").count
    if params[:category].blank?
      @category = "类别"
      @xname = @lei
      @lei.each do |lei|
        names = CustomField.find_by(name:lei).possible_values.delete_if { |item| item=="-" }
        count = PlaceRecord.where("created_at > ? and created_at < ? and province = ? and department in (?) and category = ? ",Time.new(@year,@yue,1),Time.new(@year,@yue,31),@province,names,"本体").count
        count = count/all_count.to_f*100
        count = format("%.2f",count).to_f
        @count << count
      end
    else
      @category  = params[:category]
      @xname = @ke
      @ke.each do |ke|
        count = PlaceRecord.where("created_at > ? and created_at < ? and province = ? and department = ? and category = ? ",Time.new(@year,@yue,1),Time.new(@year,@yue,31),@province,ke,"本体").count
        count = count/all_count.to_f*100
        count = format("%.2f",count).to_f
        @count << count
      end
    end
  end

  def msh_html
    if params[:time].present?
      @year = params[:time].split("-")[0]
      @yue = params[:time].split("-")[1]
    else
      @year = Time.now().year
      @yue = Time.now().month
      @time = Time.now().to_date.to_s
    end
    @ke = CustomField.find_by(id:29).possible_values.delete_if { |item| item=="-" }
    @lei = CustomField.where(id:(31..35)).pluck(:name)
    @count = []
    if params[:province].blank?
      @province = "辽宁"
    else
      @province = params[:province]
    end
    all_count = PlaceRecord.where("created_at > ? and created_at < ? and province = ? and department in (?) and category = ?",Time.new(@year,@yue,1),Time.new(@year,@yue,31),@province,@ke,"本体").count
    if params[:category] == "类别"
      @category = "类别"
      @xname = @lei
      @lei.each do |lei|
        names = CustomField.find_by(name:lei).possible_values.delete_if { |item| item=="-" }
        count = PlaceRecord.where("created_at > ? and created_at < ? and province = ? and department in (?) and category = ?",Time.new(@year,@yue,1),Time.new(@year,@yue,31),@province,names,"本体").count
        count = count/all_count.to_f*100
        count = format("%.2f",count).to_f
        @count << count
      end
    else
      @category  = params[:category]
      @xname = @ke
      @ke.each do |ke|
        count = PlaceRecord.where("created_at > ? and created_at < ? and province = ? and department = ? and category = ?",Time.new(@year,@yue,1),Time.new(@year,@yue,31),@province,ke,"本体").count
        count = count/all_count.to_f*100
        count = format("%.2f",count).to_f
        @count << count
      end
    end
    render :partial => 'ke', :layout => false
  end

  def yue_biao
    @issue = Issue.find_by(id:params[:issue_id])
    @year = Time.now().year
    @yue = [1,2,3,4,5,6,7,8,9,10,11,12]
    @count = []
    @yue.each do |yue|
      count = @issue.place_records.where("created_at > ? and created_at < ?",Time.new(@year,yue,1),Time.new(@year,yue,31)).count
      count = format("%.2f",count/CustomValue.find_by(customized_type:"Project",customized_id:1,custom_field_id:36).value.to_f*100).to_f
      @count << count
    end
  end
  def yue_biao_html
    @issue = Issue.find_by(id:params[:issue_id])
    @year = params[:year].present? ? params[:year] : Time.now().year
    @yue = [1,2,3,4,5,6,7,8,9,10,11,12]
    @count = []
    @yue.each do |yue|
      count = @issue.place_records.where("created_at > ? and created_at < ?",Time.new(@year,yue,1),Time.new(@year,yue,31)).count
      count = format("%.2f",count/CustomValue.find_by(customized_type:"Project",customized_id:1,custom_field_id:36).value.to_f*100).to_f
      @count << count
    end
    render :partial => 'yue_biao_2', :layout => false
  end

  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end

end
