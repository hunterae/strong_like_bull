require "spec_helper"
require "action_controller"

describe "StrongLikeBull" do
  before :each do
    @object = Object.new
    @object.extend(StrongLikeBull)
  end

  it "should be able to suggest the appropriate format for the example from http://www.railsexperiments.com/using-strong-parameters-with-nested-forms/" do
    inner_params = HashWithIndifferentAccess.new username: "john", data: { foo: "bar" }
    expected_format = [:username, data: [:foo]]
    params = ActionController::Parameters.new(user: inner_params)
    # sanity check that our expected format indeed does extract the inner_params out
    expect(params.require(:user).permit(expected_format)).to eql inner_params
    @object.expects(:params).returns params
    expect(@object.suggested_strong_parameters_format(:user)).to eql expected_format
  end

  it "should be able to suggest the appropriate format for the nested params example from https://github.com/rails/strong_parameters/" do
    inner_params = HashWithIndifferentAccess.new name: "john",
                                                 emails: ["test@test.com", "test2@test.com"],
                                                 friends: [ name: "Andrew", family: [:name => "Hunter"], hobbies: ["Programming"] ]
    expected_format = [:name, {:emails => []}, :friends => [ :name, { :family => [ :name ] },  { :hobbies => [] }]]
    params = ActionController::Parameters.new(user: inner_params )
    # sanity check that our expected format indeed does extract the inner_params out
    expect(params.require(:user).permit(expected_format)).to eql inner_params
    @object.expects(:params).returns params
    expect(@object.suggested_strong_parameters_format(:user)).to eql expected_format
  end

  it "should be able to suggest the appropriate format for a complex example from work (with field names randomized)" do
    inner_params = HashWithIndifferentAccess.new "random_field_1"=>"", "random_field_2"=>"",
                                                 "random_field_3"=>"", "random_field_4"=>"",
                                                 "random_field_5"=>"", "random_field_6"=>"",
                                                 "random_field_7"=>"", "random_field_8"=>"", "random_field_9"=>"",
                                                 "random_field_10"=>"", "random_field_11"=>"",
                                                 "random_field_12"=>"", "random_field_13"=>"", "random_field_14"=>"",
                                                 "random_field_15"=>"", "random_field_16"=>"",
                                                 "random_field_17"=>"",
                                                 "random_field_18"=>{"1234"=>{"random_field_19"=>"2", "value"=>"20", "id"=>"", "random_field_20"=>{"id"=>"3"}},
                                                                        "1"=>{"random_field_19"=>"2", "value"=>"30", "random_field_20"=>{"id"=>"5"}}}
    expected_format = [:random_field_1, :random_field_2, :random_field_3, :random_field_4, :random_field_5, :random_field_6, :random_field_7, :random_field_8,
                       :random_field_9, :random_field_10, :random_field_11, :random_field_12, :random_field_13, :random_field_14, :random_field_15, :random_field_16, :random_field_17,
                       {:random_field_18=>[:random_field_19, :value, :id, {:random_field_20=>[:id]}]}]
    params = ActionController::Parameters.new(variant: inner_params )
    # sanity check that our expected format indeed does extract the inner_params out
    expect(params.require(:variant).permit(expected_format)).to eql inner_params
    @object.expects(:params).returns params
    expect(@object.suggested_strong_parameters_format(:variant)).to eql expected_format
  end

  it "should be able to suggest the appropriate format for a second complex example from work (with field names randomized)" do
    inner_params = HashWithIndifferentAccess.new  "random_field_1"=>"", "random_field_2"=>"",
                                                  "random_field_3"=>"", "random_field_4"=>"234asfdsfd", "random_field_5"=>"23",
                                                  "random_field_6"=>"1", "random_field_7"=>"0.0",
                                                  "random_field_8"=>"23", "random_field_9"=>"7.5",
                                                  "random_field_10"=>"32323", "random_field_11"=>"2015-04-22",
                                                  "random_field_12"=>"", "random_field_13"=>"",
                                                  "random_field_14"=>"2", "random_field_15"=>"0",
                                                  "random_field_16"=>["", "10", "12", "30"],
                                                  "random_field_17"=>"0", "tag_list"=>["tag 1", "tag 2", "tag 3"],
                                                  "random_field_19"=>"506", "position"=>"23",
                                                  "random_field_20"=>{"0"=>{"value"=>"", "pid"=>"2"}},
                                                  "random_field_21"=>"1", "random_field_22"=>"1", "random_field_23"=>"1",
                                                  "random_field_24"=>"2fsasd", "random_field_25"=>{"value"=>"sdfafsd"},
                                                  "random_field_26"=>"", "random_field_27"=>"",
                                                  "random_field_28"=>"1", "random_field_29"=>"fadsfds",
                                                  "random_field_30"=>{"name"=>"Tim Teseterson", "random_field_97"=>"", "random_field_98"=>"", "id"=>"1234"},
                                                  "random_field_31"=>"1730", "random_field_116"=>"1", "random_field_117"=>"1", "random_field_118"=>"0",
                                                  "random_field_32"=>"", "random_field_33"=>"",
                                                  "random_field_34"=>{"title_tag"=>"", "description"=>"", "h1"=>""}
    expected_format = [:random_field_1, :random_field_2, :random_field_3, :random_field_4, :random_field_5, :random_field_6, :random_field_7,
                       :random_field_8, :random_field_9, :random_field_10, :random_field_11, :random_field_12, :random_field_13,
                       :random_field_14, :random_field_15, {:random_field_16 => []}, :random_field_17, {:tag_list => []}, :random_field_19, :position,
                       {:random_field_20 => [:value, :pid, :id]}, :random_field_21, :random_field_22, :random_field_23,
                       :random_field_24,
                       {:random_field_25 => [:value] }, :random_field_26, :random_field_27, :random_field_28, :random_field_29,
                       {:random_field_30 => [:name, :random_field_97, :random_field_98, :id]},
                       :random_field_31, :random_field_116, :random_field_117, :random_field_118, :random_field_32,
                       :random_field_33, {:random_field_34 => [:title_tag, :description, :h1]}]
    params = ActionController::Parameters.new(product: inner_params )
    # sanity check that our expected format indeed does extract the inner_params out
    expect(params.require(:product).permit(expected_format)).to eql inner_params
    @object.expects(:params).returns params
    expect(@object.suggested_strong_parameters_format(:product)).to eql expected_format
  end

  it "should be able to suggest the appropriate format for a third complex example from work (with field names randomized)" do
    inner_params = HashWithIndifferentAccess.new "random_field_1"=>"1", "random_field_3"=>"", "random_field_4"=>"", "random_field_5"=>"1", "random_field_6"=>"1", "random_field_7"=>"0",
                                                 "random_field_8"=>{"random_field_40"=>"", "url"=>"http://www.google.com", "random_field_9"=>"", "random_field_10"=>"gi",
                                                   "random_field_11"=>"", "id"=>"1234"},
                                                   "random_field_12"=>{"created_by"=>"1234", "random_field_85"=>"true", "random_field_108"=>"", "random_field_109"=>"",
                                                                                  "random_field_13"=>"", "random_field_98"=>"", "random_field_110"=>"", "random_field_97"=>"",
                                                                                  "id"=>"1234"},
                                                   "random_field_14"=>"",
                                                   "random_field_15"=>{"random_field_16"=>"", "id"=>"1234"},
                                                   "random_field_17"=>"",
                                                   "random_field_18"=>{"0"=>{"random_field_19"=>"1", "random_field_20"=>"", "random_field_21"=>"",
                                                                                          "random_field_22"=>"", "random_field_23"=>"", "random_field_24"=>"", "random_field_25"=>"1", "id"=>"1234"}},
                                                   "random_field_26"=>{"random_field_27"=>"", "random_field_28"=>"", "random_field_29"=>"", "id"=>"1234"},
                                                   "random_field_30"=>"1234", "random_field_31"=>"0", "random_field_32"=>"100.0", "random_field_33"=>"other", "random_field_34"=>"2011-01-20",
                                                   "random_field_35"=>"", "random_field_36"=>"", "random_field_37"=>"0", "random_field_38"=>"1",
                                                   "random_field_39"=>{"0"=>{"random_field_40"=>"random_field_40 1", "value"=>"0", "id"=>"1"},
                                                                                             "1"=>{"random_field_40"=>"random_field_40 2", "value"=>""},
                                                                                             "2"=>{"random_field_40"=>"random_field_40 3", "value"=>"value 3", "id"=>"2"},
                                                                                             "3"=>{"random_field_40"=>"random_field_40 4", "value"=>"value 4", "id"=>"3"},
                                                                                             "4"=>{"random_field_40"=>"random_field_40 5", "value"=>"http://www.google.com", "id"=>"4"},
                                                                                             "5"=>{"random_field_40"=>"random_field_40 6", "value"=>"0", "id"=>"5"},
                                                                                             "6"=>{"random_field_40"=>"random_field_40 7", "value"=>"0", "id"=>"6"},
                                                                                             "7"=>{"random_field_40"=>"random_field_40 8", "value"=>"0", "id"=>"7"},
                                                                                             "8"=>{"random_field_40"=>"random_field_40 9", "value"=>"0", "id"=>"8"},
                                                                                             "9"=>{"random_field_40"=>"random_field_40 10", "value"=>"0", "id"=>"9"},
                                                                                             "10"=>{"random_field_40"=>"random_field_40 11", "value"=>"0", "id"=>"10"},
                                                                                             "11"=>{"random_field_40"=>"random_field_40 12", "value"=>"0", "id"=>"11"},
                                                                                             "12"=>{"random_field_40"=>"random_field_40 13", "value"=>"0", "id"=>"12"},
                                                                                             "13"=>{"random_field_40"=>"random_field_40 14", "value"=>"some value", "id"=>"13"}},
                                                  "random_field_41"=>"0", "random_field_42"=>"0", "random_field_43"=>"0", "random_field_44"=>"0", "random_field_45"=>"0", "random_field_46"=>"0", "random_field_47"=>"0", "random_field_48"=>"0", "random_field_49"=>"1",
                                                  "random_field_50"=>"0",
                                                  "random_field_51"=>{"random_field_52"=>"0", "random_field_53"=>"1", "random_field_54"=>"0", "random_field_55"=>"0", "random_field_56"=>"0", "id"=>"1234"},
                                                  "random_field_57"=>"0", "random_field_58"=>"", "random_field_59"=>"0", "random_field_60"=>"0", "random_field_61"=>"0", "random_field_62"=>"1",
                                                  "random_field_63"=>"0", "random_field_64"=>"0", "random_field_65"=>{"random_field_66"=>""}, "random_field_67"=>"", "random_field_68"=>["1", "2"],
                                                  "random_field_69"=>"",
                                                  "random_field_70"=>{"0"=>{"random_field_13"=>"", "random_field_71(1i)"=>"2000", "random_field_71(2i)"=>"1",
                                                  "random_field_71(3i)"=>"1", "random_field_71(4i)"=>"1", "random_field_71(5i)"=>"1", "random_field_71(6i)"=>"00",
                                                  "random_field_72"=>{"random_field_73"=>"1234", "random_field_74(1i)"=>"2000", "random_field_74(2i)"=>"1", "random_field_74(3i)"=>"1", "random_field_74(4i)"=>"1", "random_field_74(5i)"=>"1", "id"=>"1234"},
                                                  "e_attributes"=>{"0"=>{"random_field_40"=>"random_field_40 1", "value"=>"3.5"},
                                                                                              "1"=>{"random_field_40"=>"random_field_40 2", "value"=>"0", "id"=>"1234"},
                                                                                              "2"=>{"random_field_40"=>"random_field_40 3", "value"=>"0", "id"=>"1234"},
                                                                                              "3"=>{"random_field_40"=>"random_field_40 4", "value"=>"http://www.flickr.com"}},
                                                  "random_field_75"=>"", "value"=>"1", "random_field_2"=>"1", "random_field_76"=>{"0"=>{"random_field_77"=>"0.0", "id"=>"1234"}},
                                                  "random_field_78"=>"n/a", "random_field_79"=>"-1", "random_field_80"=>"n/a", "random_field_81"=>"0",
                                                  "random_field_82"=>"1", "random_field_83"=>"1", "random_field_84"=>"1", "random_field_85"=>"1", "random_field_6"=>"1",
                                                  "random_field_115"=>"1", "random_field_114"=>"", "random_field_113"=>"", "random_field_112"=>"", "random_field_111"=>"false", "_destroy"=>"false", "id"=>"1234"}},
                                                  "random_field_79"=>"-1", "random_field_86"=>"0", "random_field_87"=>"1", "random_field_88"=>"No", "random_field_89"=>"1",
                                                  "random_field_90"=>"random_field_90",
                                                  "random_field_91"=>"",
                                                  "random_field_92"=>"",
                                                  "random_field_93"=>{"0"=>{"random_field_94"=>"0", "_destroy"=>"0", "id"=>"1234"},
                                                                                    "1"=>{"random_field_94"=>"0", "_destroy"=>"0", "id"=>"1234"},
                                                                                    "2"=>{"random_field_94"=>"1", "_destroy"=>"1", "random_field_98"=>""},
                                                                                    "3"=>{"random_field_94"=>"2", "_destroy"=>"1"},
                                                                                    "4"=>{"random_field_94"=>"3", "_destroy"=>"1", "random_field_97"=>""},
                                                                                    "5"=>{"random_field_94"=>"4", "_destroy"=>"1", "random_field_95"=>"0", "random_field_96"=>""}},
                                                  "random_field_102"=>{"0"=>{"random_field_20"=>"", "random_field_21"=>"", "random_field_22"=>"", "random_field_23"=>"", "random_field_24"=>"", "random_field_25"=>"1", "random_field_97"=>"",
                                                  "random_field_85"=>"0", "id"=>"2134", "_destroy"=>"false"}},
                                                  "random_field_99"=>"", "random_field_100"=>"0", "random_field_101"=>"0", "random_field_103"=>{"random_field_104"=>"", "random_field_105"=>"", "random_field_106"=>""}, "random_field_107"=>"edit"
    params = ActionController::Parameters.new(product: inner_params )
    expected_format = [:random_field_1, :random_field_3, :random_field_4, :random_field_5, :random_field_6, :random_field_7,
                       {:random_field_8=>[:random_field_40, :url, :random_field_9, :random_field_10, :random_field_11, :id]},
                       {:random_field_12=>[:created_by, :random_field_85, :random_field_108, :random_field_109, :random_field_13, :random_field_98, :random_field_110, :random_field_97, :id]},
                       :random_field_14, {:random_field_15=>[:random_field_16, :id]}, :random_field_17,
                       {:random_field_18=>[:random_field_19, :random_field_20, :random_field_21, :random_field_22, :random_field_23, :random_field_24, :random_field_25, :id]},
                       {:random_field_26=>[:random_field_27, :random_field_28, :random_field_29, :id]}, :random_field_30, :random_field_31,
                       :random_field_32, :random_field_33, :random_field_34, :random_field_35, :random_field_36, :random_field_37, :random_field_38,
                       {:random_field_39=>[:random_field_40, :value, :id]}, :random_field_41, :random_field_42, :random_field_43, :random_field_44, :random_field_45, :random_field_46, :random_field_47,
                       :random_field_48, :random_field_49, :random_field_50, {:random_field_51=>[:random_field_52, :random_field_53, :random_field_54, :random_field_55, :random_field_56, :id]},
                       :random_field_57, :random_field_58, :random_field_59, :random_field_60, :random_field_61, :random_field_62, :random_field_63, :random_field_64,
                       {:random_field_65=>[:random_field_66]}, :random_field_67, {:random_field_68=>[]}, :random_field_69,
                       {:random_field_70=>[:random_field_13, :"random_field_71(1i)", :"random_field_71(2i)", :"random_field_71(3i)", :"random_field_71(4i)", :"random_field_71(5i)", :"random_field_71(6i)",
                         {:random_field_72=>[:random_field_73, :"random_field_74(1i)", :"random_field_74(2i)", :"random_field_74(3i)", :"random_field_74(4i)", :"random_field_74(5i)", :id]},
                         {:e_attributes=>[:random_field_40, :value, :id]}, :random_field_75, :value, :random_field_2, {:random_field_76=>[:random_field_77, :id]},
                         :random_field_78, :random_field_79, :random_field_80, :random_field_81, :random_field_82, :random_field_83,
                         :random_field_84, :random_field_85, :random_field_6, :random_field_115, :random_field_114, :random_field_113, :random_field_112, :random_field_111, :_destroy, :id]},
                         :random_field_79, :random_field_86, :random_field_87, :random_field_88, :random_field_89, :random_field_90,
                         :random_field_91, :random_field_92, {:random_field_93=>[:random_field_94, :_destroy, :id, :random_field_98, :random_field_97, :random_field_95, :random_field_96]},
                         {:random_field_102=>[:random_field_20, :random_field_21, :random_field_22, :random_field_23, :random_field_24, :random_field_25, :random_field_97, :random_field_85, :id, :_destroy]}, :random_field_99, :random_field_100, :random_field_101,
                         {:random_field_103=>[:random_field_104, :random_field_105, :random_field_106]}, :random_field_107]
    @object.expects(:params).returns params
    # sanity check that our expected format indeed does extract the inner_params out
    expect(params.require(:product).permit(expected_format)).to eql inner_params
    expect(@object.suggested_strong_parameters_format(:product)).to eql expected_format
  end

  it "should combine the attributes of nested hashes" do
    inner_params = HashWithIndifferentAccess.new :products => [{:id => 50, :name => "Name 1"},
                                                               {:id => 51, :name => "Name 2", :description => "My description"},
                                                               {:name => "Name 3", :caption => "My caption"}]
    params = ActionController::Parameters.new(object: inner_params )
    expected_format = [{:products => [:id, :name, :description, :caption]}]
    @object.expects(:params).returns params
    # sanity check that our expected format indeed does extract the inner_params out
    expect(params.require(:object).permit(expected_format)).to eql inner_params
    expect(@object.suggested_strong_parameters_format(:object)).to eql expected_format
  end
end