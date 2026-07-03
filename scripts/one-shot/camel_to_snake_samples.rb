#!/usr/bin/env ruby
# One-shot: convert camelCase keys in sample YAMLs to snake_case so
# they match the gem's actual wire names (lutaml-model default).
#
# Per the model: LutaML files use camelCase; wire format is snake_case.
# This script keeps samples consistent with the wire format.

require "yaml"

SAMPLES = %w[
  samples/hybrid-board-meeting.yaml
  samples/legco-sitting-2024-01-15.yaml
  samples/oiml-ciml-56.yaml
].freeze

def snakeify(key)
  return key unless key.is_a?(String)

  key
    .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    .gsub(/([a-z\d])([A-Z])/, '\1_\2')
    .downcase
end

def walk(obj)
  case obj
  when Hash
    obj.each_with_object({}) do |(k, v), h|
      h[snakeify(k)] = walk(v)
    end
  when Array
    obj.map { |v| walk(v) }
  else
    obj
  end
end

SAMPLES.each do |path|
  next unless File.exist?(path)

  data = YAML.safe_load(File.read(path), permitted_classes: [Date, Time])
  transformed = walk(data)
  File.write(path, transformed.to_yaml)
  puts "  converted #{path}"
end

puts "done."
