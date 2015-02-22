require 'spec_helper'

# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe LineItemsController do

  # This should return the minimal set of attributes required to create a valid
  # LineItem. As you add validations to LineItem, be sure to
  # adjust the attributes here as well.

  before do
    @product = FactoryGirl.create(:product)
  end

  # let(:valid_attributes) { { "product" => @product } }
  let(:valid_attributes) do
    LineItem.new.attributes.symbolize_keys.select {|key, value| !value.nil? }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LineItemsController. Be sure to keep this updated too.

  let(:valid_session) { { "product_id" => @product.id } }
  describe "GET index" do
    it "assigns all line_items as @line_items" do
      line_item = LineItem.create! valid_attributes
      get :index, {}, valid_session
      ## should is deprecated
      assigns(:line_items).should eq([line_item])
    end
  end

  describe "GET show" do
    it "assigns the requested line_item as @line_item" do
      line_item = LineItem.create! valid_attributes
      get :show, {:id => line_item.to_param}, valid_session
      assigns(:line_item).should eq(line_item)
    end
  end

  describe "GET new" do
    it "assigns a new line_item as @line_item" do
      get :new, {}, valid_session
      assigns(:line_item).should be_a_new(LineItem)
    end
  end

  describe "GET edit" do
    it "assigns the requested line_item as @line_item" do
      line_item = LineItem.create! valid_attributes
      get :edit, {:id => line_item.to_param}, valid_session
      assigns(:line_item).should eq(line_item)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new LineItem" do
        expect {
          post :create,  valid_session
        }.to change(LineItem, :count).by(1)
      end

      it "assigns a newly created line_item as @line_item" do
        post :create,  valid_session
        assigns(:line_item).should be_a(LineItem)
        assigns(:line_item).should be_persisted
      end

      it "redirects to the created line_item" do
        post :create, valid_session
        response.should redirect_to(Cart.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved line_item as @line_item" do
        # Trigger the behavior that occurs when invalid params are submitted
        ## any_instance is deprecated
        LineItem.any_instance.stub(:save).and_return(false)
        post :create, valid_session
        expect(assigns(:line_item)).to be_a_new(LineItem)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        LineItem.any_instance.stub(:save).and_return(false)
        post :create, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested line_item" do
        line_item = LineItem.create! valid_attributes
        line_item.product = @product
        # Assuming there are no other line_items in the database, this
        # specifies that the LineItem created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        LineItem.any_instance.should_receive(:update).with({ "product_id" => @product.id.to_s })
        put :update, { id: line_item.id, line_item: { product_id: @product.id }, line_item_ids: line_item.id }
      end

      it "assigns the requested line_item as @line_item" do
        line_item = LineItem.create! valid_attributes
        put :update, id: line_item.id, line_item: { item_id: @product.item_id }, line_item_ids: line_item.id

        assigns(:line_item).should eq(line_item)
      end

      it "redirects to the line_item" do
        line_item = LineItem.create! valid_attributes
        line_item.product = @product
        line_item.cart = Cart.create
        put :update, { id: line_item.id, line_item: { item_id: @product.item_id }, line_item_ids: line_item.id }
        response.should redirect_to(line_item)
      end
    end

    describe "with invalid params" do
      it "assigns the line_item as @line_item" do
        line_item = LineItem.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LineItem.any_instance.stub(:save).and_return(false)
        put :update, {:id => line_item.to_param, :line_item => { "product" => "invalid value" }, line_item_ids: line_item.id }, valid_session
        assigns(:line_item).should eq(line_item)
      end

      it "re-renders the 'edit' template" do
        line_item = LineItem.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LineItem.any_instance.stub(:save).and_return(false)
        put :update, {:id => line_item.to_param, :line_item => { "product" => "invalid value" }, line_item_ids: line_item.id }, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested line_item" do
      line_item = LineItem.create! valid_attributes
      expect {
        delete :destroy, :id => line_item.to_param, line_item_ids: line_item.to_param
      }.to change(LineItem, :count).by(-1)
    end

    it "redirects to the line_items list" do
      line_item = LineItem.create! valid_attributes
      delete :destroy, {:id => line_item.to_param, line_item_ids: line_item.to_param }, valid_session
      response.should redirect_to(line_items_url)
    end
  end
end
