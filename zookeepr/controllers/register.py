from sqlalchemy import create_session

from zookeepr.lib.base import *

class RegisterController(BaseController):
    def index(self):
        m.subexec('register/new.myt')

    def confirm(self, id):
        """Confirm a registration with the given ID.

        `id` is a md5 hash of the email address of the registrant, the time
        they regsitered, and a nonce.

        """
        session = create_session()

        r = session.query(model.Registration).select_by(url_hash=id)

        if len(r) < 1:
            m.abort(404)
        
        #print r

        m.subexec('register/confirmed.myt')
