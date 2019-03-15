
A small example of working with a configMap

 create a config map with a file
~~~
oc create configmap my-config-map --from-file=simple.txt
~~~

*Note*: configmap name must be lower case and “-” or “.”

To list configmaps created
~~~
oc describe configmaps
~~~
To list just the config map my-config-map
~~~
oc describe configmaps my-config-map
~~~

To get the yaml definition of the config map object
~~~
oc get configmaps my-config-map -o yaml
~~~


To attach config map to dc as a volume using CLI

~~~
oc volume dc/mysimplejavaexample --add --name=myconfig  -m /opt/myconfig -t configmap --configmap-name=my-config-map
~~

To verify the configMap has been attached

~~~
oc rsh <podname>
~~~

Ensure the file  simple.txt is available in the pod

~~~~
/opt/myconfig $ ls
simple.txt
/opt/myconfig $ cat simple.txt
prop1=value1
prop2=value2
prop3=value3
/opt/myconfig $
~~~~

To update the config (with an edit)
~~~
oc edit configmap my-config-map
~~~
