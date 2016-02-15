require 'rails_helper'

RSpec.describe "passive_data_points/show", type: :view do
  before(:each) do
    @passive_data_point = assign(:passive_data_point, PassiveDataPoint.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/User/)
    expect(rendered).to match(/Integer/)
    expect(rendered).to match(/Was User Entered/)
    expect(rendered).to match(/Boolean/)
    expect(rendered).to match(/Timezone/)
    expect(rendered).to match(/String/)
    expect(rendered).to match(/Source Uuid/)
    expect(rendered).to match(/String/)
    expect(rendered).to match(/External Uuid/)
    expect(rendered).to match(/String/)
    expect(rendered).to match(/Creation Date Time/)
    expect(rendered).to match(/Date/)
    expect(rendered).to match(/Schema Namespace/)
    expect(rendered).to match(/String/)
    expect(rendered).to match(/Schema Name/)
    expect(rendered).to match(/String/)
    expect(rendered).to match(/Schema Version/)
    expect(rendered).to match(/String/)
  end
end
