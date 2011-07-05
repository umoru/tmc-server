=begin
require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ExerciseReturnsController do

  # This should return the minimal set of attributes required to create a valid
  # ExerciseReturn. As you add validations to ExerciseReturn, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all exercise_returns as @exercise_returns" do
      exercise_return = ExerciseReturn.create! valid_attributes
      get :index
      assigns(:exercise_returns).should eq([exercise_return])
    end
  end

  describe "GET show" do
    it "assigns the requested exercise_return as @exercise_return" do
      exercise_return = ExerciseReturn.create! valid_attributes
      get :show, :id => exercise_return.id.to_s
      assigns(:exercise_return).should eq(exercise_return)
    end
  end

  describe "GET new" do
    it "assigns a new exercise_return as @exercise_return" do
      get :new
      assigns(:exercise_return).should be_a_new(ExerciseReturn)
    end
  end

  describe "GET edit" do
    it "assigns the requested exercise_return as @exercise_return" do
      exercise_return = ExerciseReturn.create! valid_attributes
      get :edit, :id => exercise_return.id.to_s
      assigns(:exercise_return).should eq(exercise_return)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ExerciseReturn" do
        expect {
          post :create, :exercise_return => valid_attributes
        }.to change(ExerciseReturn, :count).by(1)
      end

      it "assigns a newly created exercise_return as @exercise_return" do
        post :create, :exercise_return => valid_attributes
        assigns(:exercise_return).should be_a(ExerciseReturn)
        assigns(:exercise_return).should be_persisted
      end

      it "redirects to the created exercise_return" do
        post :create, :exercise_return => valid_attributes
        response.should redirect_to(ExerciseReturn.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved exercise_return as @exercise_return" do
        # Trigger the behavior that occurs when invalid params are submitted
        ExerciseReturn.any_instance.stub(:save).and_return(false)
        post :create, :exercise_return => {}
        assigns(:exercise_return).should be_a_new(ExerciseReturn)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ExerciseReturn.any_instance.stub(:save).and_return(false)
        post :create, :exercise_return => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested exercise_return" do
        exercise_return = ExerciseReturn.create! valid_attributes
        # Assuming there are no other exercise_returns in the database, this
        # specifies that the ExerciseReturn created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ExerciseReturn.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => exercise_return.id, :exercise_return => {'these' => 'params'}
      end

      it "assigns the requested exercise_return as @exercise_return" do
        exercise_return = ExerciseReturn.create! valid_attributes
        put :update, :id => exercise_return.id, :exercise_return => valid_attributes
        assigns(:exercise_return).should eq(exercise_return)
      end

      it "redirects to the exercise_return" do
        exercise_return = ExerciseReturn.create! valid_attributes
        put :update, :id => exercise_return.id, :exercise_return => valid_attributes
        response.should redirect_to(exercise_return)
      end
    end

    describe "with invalid params" do
      it "assigns the exercise_return as @exercise_return" do
        exercise_return = ExerciseReturn.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ExerciseReturn.any_instance.stub(:save).and_return(false)
        put :update, :id => exercise_return.id.to_s, :exercise_return => {}
        assigns(:exercise_return).should eq(exercise_return)
      end

      it "re-renders the 'edit' template" do
        exercise_return = ExerciseReturn.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ExerciseReturn.any_instance.stub(:save).and_return(false)
        put :update, :id => exercise_return.id.to_s, :exercise_return => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested exercise_return" do
      exercise_return = ExerciseReturn.create! valid_attributes
      expect {
        delete :destroy, :id => exercise_return.id.to_s
      }.to change(ExerciseReturn, :count).by(-1)
    end

    it "redirects to the exercise_returns list" do
      exercise_return = ExerciseReturn.create! valid_attributes
      delete :destroy, :id => exercise_return.id.to_s
      response.should redirect_to(exercise_returns_url)
    end
  end

end
=end