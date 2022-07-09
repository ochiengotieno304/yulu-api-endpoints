class User < ApplicationRecord
  has_secure_password

  enum :status, [:out, :in]
end
