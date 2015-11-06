class CapturePolicy < ApplicationPolicy
  def update_capture?
    if user
      true
    else
      false
    end
  end
end