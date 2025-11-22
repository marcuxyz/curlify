require 'yaml'

class Settings
  ROOT_DIR = File.expand_path('..', __dir__)

  def self.call
    new.send(:load_yaml_config_file)
  end

  private

  def load_yaml_config_file
    YAML.load(read_file).transform_keys(&:to_sym)
  end

  def read_file
    config_path = File.join(ROOT_DIR, 'config', 'settings.yaml')
    File.read(config_path)
  end
end
