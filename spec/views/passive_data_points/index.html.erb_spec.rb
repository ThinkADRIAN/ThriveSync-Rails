require 'rails_helper'

RSpec.describe "passive_data_points/index", type: :view do
  before(:each) do
    assign(:passive_data_points, [
      PassiveDataPoint.create!(
        :user_id => "User",
        :integer => "Integer",
        :was_user_entered => "Was User Entered",
        :boolean => "Boolean",
        :timezone => "Timezone",
        :string => "String",
        :source_uuid => "Source Uuid",
        :string => "String",
        :external_uuid => "External Uuid",
        :string => "String",
        :creation_date_time => "Creation Date Time",
        :date => "Date",
        :schema_namespace => "Schema Namespace",
        :string => "String",
        :schema_name => "Schema Name",
        :string => "String",
        :schema_version => "Schema Version",
        :string => "String"
      ),
      PassiveDataPoint.create!(
        :user_id => "User",
        :integer => "Integer",
        :was_user_entered => "Was User Entered",
        :boolean => "Boolean",
        :timezone => "Timezone",
        :string => "String",
        :source_uuid => "Source Uuid",
        :string => "String",
        :external_uuid => "External Uuid",
        :string => "String",
        :creation_date_time => "Creation Date Time",
        :date => "Date",
        :schema_namespace => "Schema Namespace",
        :string => "String",
        :schema_name => "Schema Name",
        :string => "String",
        :schema_version => "Schema Version",
        :string => "String"
      )
    ])
  end

  it "renders a list of passive_data_points" do
    render
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => "Integer".to_s, :count => 2
    assert_select "tr>td", :text => "Was User Entered".to_s, :count => 2
    assert_select "tr>td", :text => "Boolean".to_s, :count => 2
    assert_select "tr>td", :text => "Timezone".to_s, :count => 2
    assert_select "tr>td", :text => "String".to_s, :count => 2
    assert_select "tr>td", :text => "Source Uuid".to_s, :count => 2
    assert_select "tr>td", :text => "String".to_s, :count => 2
    assert_select "tr>td", :text => "External Uuid".to_s, :count => 2
    assert_select "tr>td", :text => "String".to_s, :count => 2
    assert_select "tr>td", :text => "Creation Date Time".to_s, :count => 2
    assert_select "tr>td", :text => "Date".to_s, :count => 2
    assert_select "tr>td", :text => "Schema Namespace".to_s, :count => 2
    assert_select "tr>td", :text => "String".to_s, :count => 2
    assert_select "tr>td", :text => "Schema Name".to_s, :count => 2
    assert_select "tr>td", :text => "String".to_s, :count => 2
    assert_select "tr>td", :text => "Schema Version".to_s, :count => 2
    assert_select "tr>td", :text => "String".to_s, :count => 2
  end
end
