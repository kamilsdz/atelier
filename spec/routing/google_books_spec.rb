require "rails_helper"

RSpec.describe 'routes to the google_books', type: :routing do
  it { expect(get: '/google-isbn').to route_to('google_books#show') }
  it { expect(get: '/users/sign_in').to route_to('devise/sessions#new') }
  it { expect(post: '/users/sign_in').to route_to('devise/sessions#create') }
  it { expect(delete: '/users/sign_out').to route_to('devise/sessions#destroy') }
  it { expect(get: '/users/password/new').to route_to('devise/passwords#new') }
  it { expect(get: '/users/password/new').to route_to('devise/passwords#new') }
  it { expect(get: '/users/password/edit').to route_to('devise/passwords#edit') }
  it { expect(patch: '/users/password').to route_to('devise/passwords#update') }

  it { expect(put: '/books/1').to route_to('books#update', id: '1') }
  it { expect(delete: '/books/1').to route_to('books#destroy', id: '1') }
  it { expect(get: '/books/1/take').to route_to('reservations#take', book_id: '1') }
end
