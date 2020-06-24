#!/var/www/venv/bin/python3

# Initialize Python environment to leverage Django content
import sys
sys.path.append('/var/www/clus20_django')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'clus20_django.settings')

# Initialize Django
import django
django.setup()

# Import Django models
from django.core import management
from django.contrib.auth import get_user_model
from polls.models import Choice, Question
from django.utils import timezone


if __name__ == '__main__':
    # https://docs.djangoproject.com/en/3.0/ref/django-admin/#django.core.management.call_command
    management.call_command('makemigrations', 'polls')
    management.call_command('migrate')

    # https://stackoverflow.com/questions/6244382/how-to-automate-createsuperuser-on-django
    User = get_user_model()
    User.objects.create_superuser('admin', 'admin@clus20.example.com', 'admin')

    # Populate example poll questions
    # https://docs.djangoproject.com/en/3.0/intro/tutorial02/
    q = Question(question_text="What's new?", pub_date=timezone.now())
    q.save()

    q.choice_set.create(choice_text='Not much', votes=0)
    q.choice_set.create(choice_text='The sky', votes=0)
    q.choice_set.create(choice_text='Just hacking again', votes=0)
