#
# Copyright 2011, Andrew Fulcher
#
# This file is part of Ebs2s3.
#
# Ebs2s3 is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Ebs2s3 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ebs2s3.  If not, see <http://www.gnu.org/licenses/>.
#

class UserSession < Authlogic::Session::Base
  
  # Rails 3 fix
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
  
end
