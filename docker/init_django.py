#!/var/www/venv/bin/python3

from django.core.management.utils import get_random_secret_key

def write_to_file(secret_key):
    with open('/var/www/secret_key.txt', 'w') as f:
        f.write(secret_key)

if __name__ == '__main__':
    secret_key = get_random_secret_key()

    # Very straighforward - if I can't write to /var/www/secret_key.txt
    # then echo it to the stdout and assume a redirect is happening
    try:
        write_to_file(secret_key)
    except:
        print(secret_key)
