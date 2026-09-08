# Railway build fix

If the Railway build log shows:

`fatal error: linux/sock_diag.h: No such file or directory`

then the Alpine image is missing Linux kernel headers while PHP compiles `ext-sockets`.
This project installs `linux-headers` before `docker-php-ext-install`, which fixes that build failure.

## Deploy
1. Push this corrected project to the same GitHub repo.
2. Railway -> service -> Deployments -> Redeploy latest commit.
3. After the build succeeds, Settings -> Networking -> Generate Domain.
4. Set `REVERB_HOST` to the generated hostname without `https://`.
5. Redeploy once after setting variables.
