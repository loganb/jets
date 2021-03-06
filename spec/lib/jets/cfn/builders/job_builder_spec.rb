describe Jets::Cfn::Builders::JobBuilder do
  let(:builder) do
    Jets::Cfn::Builders::JobBuilder.new(HardJob)
  end

  describe "compose" do
    it "builds a child stack with the scheduled events" do
      builder.compose
      # puts builder.text # uncomment to see template text

      resources = builder.template["Resources"]
      expect(resources).to include("DigLambdaFunction")
      expect(resources).to include("DigPermission")
      expect(resources).to include("LiftEventsRule")

      expect(builder.template_path).to eq "#{Jets.build_root}/templates/demo-test-app-hard_job.yml"
    end
  end
end
