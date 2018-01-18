require 'spec_helper'

RSpec.describe Userlist::Config do
  subject { described_class.new }

  after do
    ENV.keys.grep(/USERLIST/).each { |key| ENV.delete(key) }
  end

  describe 'extending the default configuration' do
    it 'should be possible to add new configuration values' do
      config_class = Class.new(described_class) do
        def default_config
          super.merge(from_class: 'class')
        end
      end

      config_module = Module.new do
        def default_config
          super.merge(from_module: 'module')
        end
      end

      config_class.send(:prepend, config_module)

      config = config_class.new

      expect(config.from_class).to eq('class')
      expect(config.from_module).to eq('module')
    end
  end

  describe '#push_key' do
    it 'should have a default value' do
      expect(subject.push_key).to eq(nil)
    end

    it 'should accept values from the ENV' do
      ENV['USERLIST_PUSH_KEY'] = 'push-key-from-env'
      expect(subject.push_key).to eq('push-key-from-env')
    end

    it 'should accept values via the setter' do
      subject.push_key = 'push-key-from-setter'
      expect(subject.push_key).to eq('push-key-from-setter')
    end
  end

  describe '#push_endpoint' do
    it 'should have a default value' do
      expect(subject.push_endpoint).to eq('https://push.userlist.io/')
    end

    it 'should accept values from the ENV' do
      ENV['USERLIST_PUSH_ENDPOINT'] = 'https://push.from.env/'
      expect(subject.push_endpoint).to eq('https://push.from.env/')
    end

    it 'should accept values via the setter' do
      subject.push_endpoint = 'https://push.from.setter/'
      expect(subject.push_endpoint).to eq('https://push.from.setter/')
    end
  end
end
