# Scale your IBM Cloud Code Engine app up and down on schedule
#### Scale an IBM Cloud Code Engine app up and down based on schedule using cron subscriptions

You can set up automatic scaling of your apps deployed to IBM Cloud Code Engine. Use the code in this repository as blueprint and adapt it to your needs.

1. Login to IBM Cloud, select the resource group and region.
2. Target your IBM Cloud Code Engine project.
3. Copy over ce_secrets.sample.txt to **ce_secrets.txt**. Adapt to your needs.
4. Create a new secret with the environment variables:
   ```
   ibmcloud ce secret create --name scaling-secrets --from-env-file ce_secrets.txt
   ```
5. Build and push the container image or use Code Engine image builds.
6. If not available, create a registry access secret.
7. Create the job:
   ```
   ibmcloud ce job create -n scalingjob --image us.icr.io/namespace/image_name:tag --env-from-secret scaling-secrets
   ```
8. Create the cron subscriptions for the scheduled scaling:   
   Scale down at 22:00 in my time zone. No additional parameters are required because CE_MIN_SCALE has a default value of zero in the secret.
   ```
   ibmcloud ce subscription cron create --name scaledown --destination scalingjob --schedule '0 22 * * *' --destination-type job --tz Europe/Berlin
   ```
   To scale up at, e.g. 8:30, to a minimum of one instance, we need to pass that value as data.
   ```
   ibmcloud ce subscription cron create --name scaleup --destination scalingjob --schedule '30 8 * * *' --destination-type job --tz Europe/Berlin --data '{"CE_MIN_SCALE":1}' --ct application/json
   ```
   
Check the logs for successful runs. You can also test manually, by running the following commands. 
- Set min-scale to 2:
  ```
  ibmcloud ce jobrun submit -n scalingjob-run1 --job scalingjob --env CE_MIN_SCALE=2
  ```
- Set min-scale to 0: 
  ```
  ibmcloud ce jobrun submit -n scalingjob-run2 --job scalingjob 
  ```
