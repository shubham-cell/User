class Document < ApplicationRecord
    has_many_attached :files
    belongs_to :user

    validate :files_size

    private

    def files_size
        files.each do |file|
            if file.blob.byte_size > 1.megabyte
                errors.add(:files, "each file should be less than 1 MB")
            end
        end
    end
end