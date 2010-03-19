
authorization do
  role :admin do
    has_permission_on :users, :to => :manage
    has_permission_on :books, :to => :manage
    includes :user
  end
  role :user do
    includes :guest
  end
  role :guest do
    has_permission_on :books, :to => :read
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end

