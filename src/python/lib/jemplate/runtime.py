class JemplateRuntime():
    def __init__(self):
        pass

    def render(self, path, data={}):
        self.lookup = self.template_dict()
        self.ctx = {
            'stash': data,
        }
        return self.process(path, {})

    def find_template(self, path):
        # TODO real path lookup
        return self.lookup[path]

    def process(self, path, var={}):
        return self.find_template(path)()

    def get(self, var):
        return self.ctx['stash'].get(var, '')
