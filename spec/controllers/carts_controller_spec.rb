require 'spec_helper'

# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe CartsController do

  # This should return the minimal set of attributes required to create a valid
  # Cart. As you add validations to Cart, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {  } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CartsController. Be sure to keep this updated too.
  let(:valid_session) { { } }

  describe "GET index" do
    it "assigns all carts as @carts" do
      cart = Cart.create! valid_attributes
      get :index, {}, valid_session
      assigns(:carts).should eq([cart])
    end
  end

  describe "GET show" do
    it "assigns the requested cart as @cart" do
      cart = Cart.create! valid_attributes
      get :show, {:id => cart.to_param}, valid_session
      assigns(:cart).should eq(cart)
    end
  end

  describe "GET new" do
    it "assigns a new cart as @cart" do
      get :new, {}, valid_session
      assigns(:cart).should be_a_new(Cart)
    end
  end

  describe "GET edit" do
    it "assigns the requested cart as @cart" do
      cart = Cart.create! valid_attributes
      get :edit, {:id => cart.to_param}, valid_session
      assigns(:cart).should eq(cart)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Cart" do
        expect {
          post :create, {:cart => valid_attributes}, valid_session
        }.to change(Cart, :count).by(1)
      end

      it "assigns a newly created cart as @cart" do
        post :create, {:cart => valid_attributes}, valid_session
        assigns(:cart).should be_a(Cart)
        assigns(:cart).should be_persisted
      end

      it "redirects to the created cart" do
        post :create, {:cart => valid_attributes}, valid_session
        response.should redirect_to(Cart.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved cart as @cart" do
        # Trigger the behavior that occurs when invalid params are submitted
        Cart.any_instance.stub(:save).and_return(false)
        post :create, {:cart => {  }}, valid_session
        assigns(:cart).should be_a_new(Cart)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Cart.any_instance.stub(:save).and_return(false)
        post :create, {:cart => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested cart" do
        cart = Cart.create! valid_attributes
        # Assuming there are no other carts in the database, this
        # specifies that the Cart created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Cart.any_instance.should_receive(:update).with({ "these" => "params" })
        put :update, {:id => cart.to_param, :cart => { "these" => "params" }}, valid_session
      end

      it "assigns the requested cart as @cart" do
        cart = Cart.create! valid_attributes
        put :update, {:id => cart.to_param, :cart => valid_attributes}, valid_session
        assigns(:cart).should eq(cart)
      end

      it "redirects to the cart" do
        cart = Cart.create! valid_attributes
        put :update, {:id => cart.to_param, :cart => valid_attributes}, valid_session
        response.should redirect_to(cart)
      end
    end

    describe "with invalid params" do
      it "assigns the cart as @cart" do
        cart = Cart.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Cart.any_instance.stub(:save).and_return(false)
        put :update, {:id => cart.to_param, :cart => {  }}, valid_session
        assigns(:cart).should eq(cart)
      end

      it "re-renders the 'edit' template" do
        cart = Cart.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Cart.any_instance.stub(:save).and_return(false)
        put :update, {:id => cart.to_param, :cart => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested cart" do
      cart = Cart.create! valid_attributes
      valid_session = { cart_id: cart.id }
      expect {
        delete :destroy, {:id => cart.to_param }, valid_session
      }.to change(Cart, :count).by(-1)
    end

    it "redirects to the carts list" do
      cart = Cart.create! valid_attributes
      delete :destroy, {:id => cart.to_param, line_item_ids: cart.id }, valid_session
      response.should redirect_to(products_index_url)
    end
  end

end
