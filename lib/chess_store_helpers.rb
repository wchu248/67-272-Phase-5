# require needed files
require 'helpers/validations'
require 'helpers/cart'
require 'helpers/shipping'

module ChessStoreHelpers
  include ChessStoreHelpers::Validations
  include ChessStoreHelpers::Shipping
  include ChessStoreHelpers::Cart
end