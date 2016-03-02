require "xcodeproj"
require "xcodeproj_merge/version"

class XcodeprojMerge
  def initialize(source_project_path, destination_project_path)
    @source      = Xcodeproj::Project.open(source_project_path)
    @destination = Xcodeproj::Project.open(destination_project_path)
  end

  attr_reader :source, :destination

  def call
    build_phase_names.each do |phase_name|
      merge_file_references_for_phase(phase_name)
    end
    destination.save
  end

  private

  def build_phase_names
    %w(source_build_phase frameworks_build_phases resources_build_phase headers_build_phase)
  end

  def default_target(project)
    project.targets[0] or raise "No target found in #{project}"
  end

  def merge_file_references_for_phase(phase_name)
    source_phase = default_target(source).send(phase_name)
    destination_phase = default_target(destination).send(phase_name)

    source_phase.files_references.each do |source_ref|
      unless destination_phase.files_references.include?(source_ref)
        add_file_reference(source_ref, destination_phase)
      end
    end
  end

  def add_file_reference(source_ref, phase)
    group = destination[source_ref.parent.path] || destination.main_group
    existing_ref = group.files.grep(source_ref).first

    destination_ref = existing_ref || group.new_reference(source_ref.path)
    destination_ref.fileEncoding = source_ref.fileEncoding
    destination_ref.include_in_index = source_ref.include_in_index

    phase.add_file_reference(destination_ref, true)
  end
end
