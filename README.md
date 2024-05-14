class jorozco(self):
        self.username = 'wwitmovil'
        self.name = 'Jeyson Orozco Herrera'
        self.web = 'https://witmovil.com'
        self.resume = 'https://github.com/witmovil/documents/blob/main/resume_jeyson_orozco.pdf'
        self.twitter = '@jeyson.orozco'
        self.linkedin = 'https://www.linkedin.com/in/jeyson-orozco/'
        seld.dev = 'https://dev.to/'
        self.source = {
            'born': ['Colombia','Barranquilla'],
            'I have lived': ['Chile','Santiago de Chile'],
            'Where I live': ['Colombia','Barranquilla'],
        },
        self.studies = {
            'graduate': ['Sistem engineer','Cun'],
            'postgraduate': ['master in dessarrollo web','UIS']
        },
        self.architecture = ['MVC', 'microservices'],
        self.code = {
            'erp': ['odoo erp', 'sap r3'],
            'frontend': ['HTML', 'CSS', 'JavaScript', 'Boostrap','React'],
            'backend': ['Python', 'PHP', 'Node.Js'],
            'database': ['MySQL', 'MongoDB'],
            'devops': ['Docker', 'Nginx', 'AWS','Docker-compose'],
            'tools': ['GIT', 'GitHub'],
            'ides': ['Visual Studio Code'],
            'misc': ['Firebase', 'SCRUM', 'GNU/Linux', 'windows']
        },
        self.projects = {
            'witmovil': [https://witmovil.com/][WORDPRESS],
            'XtremeNetworks': [https://xtremenetworks.com.co/][WORDPRESS],
            'LEGALGROUP': [http://legalgroupsolucionesintegrales.com/][WORDPRESS],
            'OPTICSECONOMICS': [https://opticseconomics.com/][WORDPRESS]
        }
        

    def __str__(self):
        return self.name


if __name__ == '__main__':
    me = jorozco()
