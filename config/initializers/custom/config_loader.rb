# frozen_string_literal: true

CONF = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
