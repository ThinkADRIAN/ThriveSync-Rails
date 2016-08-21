require 'rails_helper'

RSpec.describe "passive_data_points/edit", type: :view do
  before(:each) do
    @passive_data_point = assign(:passive_data_point, PassiveDataPoint.create!(
      :user_id => "MyString",
      :integer => "MyString",
      :was_user_entered => "MyString",
      :boolean => "MyString",
      :timezone => "MyString",
      :string => "MyString",
      :source_uuid => "MyString",
      :string => "MyString",
      :external_uuid => "MyString",
      :string => "MyString",
      :creation_date_time => "MyString",
      :date => "MyString",
      :schema_namespace => "MyString",
      :string => "MyString",
      :schema_name => "MyString",
      :string => "MyString",
      :schema_version => "MyString",
      :string => "MyString"
    ))
  end

  it "renders the edit passive_data_point form" do
    render

    assert_select "form[action=?][method=?]", passive_data_point_path(@passive_data_point), "post" do

      assert_select "input#passive_data_point_user_id[name=?]", "passive_data_point[user_id]"

      assert_select "input#passive_data_point_integer[name=?]", "passive_data_point[integer]"

      assert_select "input#passive_data_point_was_user_entered[name=?]", "passive_data_point[was_user_entered]"

      assert_select "input#passive_data_point_boolean[name=?]", "passive_data_point[boolean]"

      assert_select "input#passive_data_point_timezone[name=?]", "passive_data_point[timezone]"

      assert_select "input#passive_data_point_string[name=?]", "passive_data_point[string]"

      assert_select "input#passive_data_point_source_uuid[name=?]", "passive_data_point[source_uuid]"

      assert_select "input#passive_data_point_string[name=?]", "passive_data_point[string]"

      assert_select "input#passive_data_point_external_uuid[name=?]", "passive_data_point[external_uuid]"

      assert_select "input#passive_data_point_string[name=?]", "passive_data_point[string]"

      assert_select "input#passive_data_point_creation_date_time[name=?]", "passive_data_point[creation_date_time]"

      assert_select "input#passive_data_point_date[name=?]", "passive_data_point[date]"

      assert_select "input#passive_data_point_schema_namespace[name=?]", "passive_data_point[schema_namespace]"

      assert_select "input#passive_data_point_string[name=?]", "passive_data_point[string]"

      assert_select "input#passive_data_point_schema_name[name=?]", "passive_data_point[schema_name]"

      assert_select "input#passive_data_point_string[name=?]", "passive_data_point[string]"

      assert_select "input#passive_data_point_schema_version[name=?]", "passive_data_point[schema_version]"

      assert_select "input#passive_data_point_string[name=?]", "passive_data_point[string]"
    end
  end
end
