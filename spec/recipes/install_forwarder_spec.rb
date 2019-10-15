require 'spec_helper'

describe 'chef-splunk::install_forwarder' do
  platforms = {
    debian: {
      runner: {
        platform: 'ubuntu',
        version: '16.04',
      },
      url: 'http://splunk.example.com/forwarder/package.deb',
    },
    redhat: {
      runner: {
        platform: 'centos',
        version: '7',
      },
      url: 'http://splunk.example.com/forwarder/package.rpm',
    },
  }

  platforms.each do |platform, platform_under_test|
    context "#{platform} family" do
      let(:url) { platform_under_test[:url] }

      let(:chef_run) do
        ChefSpec::ServerRunner.new(platform_under_test[:runner])
      end

      it 'ran the splunk installer' do
        chef_run.node.force_default['splunk']['forwarder']['url'] = url
        chef_run.converge(described_recipe)
        expect(chef_run).to run_splunk_installer('splunkforwarder').with(url: url)
      end
    end
  end
end
