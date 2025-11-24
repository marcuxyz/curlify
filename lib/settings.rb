require 'yaml'

class Settings
  def self.call
    new.send(:params)
  end

  private

  def params
    YAML.safe_load(
      read_file,
      permitted_classes: [],
      permitted_symbols: [],
      aliases: true
    )
  end

  def read_file
    File.read(
      File.join('config', 'settings.yml')
    )
  end
end
