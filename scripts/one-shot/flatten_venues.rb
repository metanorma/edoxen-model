#!/usr/bin/env ruby
# One-shot: flatten nested `physical_venue:` / `virtual_venue:` keys
# up into the parent venue object, so the wire format matches the
# polymorphic inheritance used by the gem (Venue → PhysicalVenue / VirtualVenue).

require "yaml"

SAMPLES = %w[
  samples/hybrid-board-meeting.yaml
  samples/legco-sitting-2024-01-15.yaml
  samples/oiml-ciml-56.yaml
].freeze

NESTED_VENUE_KEYS = %w[physical_venue virtual_venue].freeze

def flatten_venues(obj)
  case obj
  when Hash
    obj.each_with_object({}) do |(k, v), h|
      if k == "venues" && v.is_a?(Array)
        h[k] = v.map { |venue| flatten_venue(venue) }
      else
        h[k] = flatten_venues(v)
      end
    end
  when Array
    obj.map { |v| flatten_venues(v) }
  else
    obj
  end
end

def flatten_venue(venue)
  return venue unless venue.is_a?(Hash)

  flattened = {}
  venue.each do |k, v|
    if NESTED_VENUE_KEYS.include?(k) && v.is_a?(Hash)
      v.each { |nested_k, nested_v| flattened[nested_k] = nested_v }
    else
      flattened[k] = flatten_venues(v)
    end
  end
  flattened
end

SAMPLES.each do |path|
  next unless File.exist?(path)

  data = YAML.safe_load(File.read(path), permitted_classes: [Date, Time])
  flattened = flatten_venues(data)
  File.write(path, flattened.to_yaml)
  puts "  flattened #{path}"
end

puts "done."
