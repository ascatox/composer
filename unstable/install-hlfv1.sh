(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �.Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[�/�$!�:���Q����u|���`�_>H�&�W�&���;|Aq�I��1�������Ӝ��dk;�վ�S{;�^.�Z�?�#�'��v��^N�z/��˟�	��xM��)����!ŵ�x���/ީ.�?Jٕ�K���{�+��[G���'�j���_����g�8�_�˟�i�������t�eؙ.�t���)�����k��GcAQ�.��'�������g�^����c�?��.��.�y��S6�6Z�a��X�$l�sY��|�t|ԧ)��\��(�EQ�'����^������?E���q}����s�RF�����Nl�jM�>��t��Xk��)R�.4Q�e$�e���$X`�{+X�R\�ʦ�m�0R�?����_5�
�B ��@���c%�&�'pG���&�OQ4�!
�\gu���=���p:�JH�w��L�	k[�ˋY�E�[�~dK��B]��:5VT��������4�m/�.]?]��1����0�Z�+%�������ď����{����)x��yQ7dI��y��e�o<�nr���)K�Of}o�9�5��E����p5�Ϻ=M��-�!^�S�b�2�P�t ���0)�����e�C��Ny�NQ����������3� �
`��(��0�ݏ�N4@�U���7��x�깑�S8b	��+��+���B3	�\��{�p��[��Q��܂���@��5�?W'Nc9xkcŝ4�s�kf�7�n$m,lq�0�U�����\�O�"��$ͽ������Nip�3m�P<Q(tzSP(@d���*F����͡]_�w#�L	��0{�nq��V�����Mm@;a���K�*nG(�JK�2qs��3���58O���=!98�ģȓ����/z^ .ԏ���4<�\XR����G��H��eQV���I9h�71��oVL�̖�Q��@���Fc$J�Ms�<0
Q� 	�"xY����Ɂ\&�$�H�Kqc6˨�9�v��oX���[NҖ�FSŋQW2Y1��@�E#�3�^<�F�.����lx6���Y~I�g�����G��K���Q�S�U�G��?�.a��%�5�g�;���@=2̛흺_���@�8��В��X>̐#q���^B�Џ��
|Hʑ�z E�����di���2s��I���:��2��4]�!�l��b��p��#v�D���[�NyM1GkH���5q"5q1u{����~o�yl��W�y.�V��
������2t����[���˶:U �U��ք9P�m�0<Z GZoi�rf�m qy���+ ���TɌ�\�A����}� ����堛��>�u�^��[��kSR�G�D������:��u�E��`f����d_��8�#�f5�7�~�&��� 7ؽߤی�	��97�~&׵d:\M�6��C%�u���|����]�������d�Q
>D�?s�����G�bHT�_*����+��ϵ~A��9&�r�'�����_��g��T�_)�����_���O�N����W'�)�-~��); 	h�e0�u(��%�q�#�*���B����Q�EЕ�W.����=q�w4)h��Hc=A]f��\�������F��/���ec�m+��qCN���o�|�-[ʰ�l��a��%ǜ�L7�t;��=�csc����
p;�nX@�$�m��=�������g��T��������?D���@��W��U���߻��g��T�_
>H���?"�����������ߛ9	�G(L���.@^����`�����%��7kpl�L̇0�н�4��ށ
��*@�tb�I�7���txs�;��H��H�\u:w��f�z3�7l�k���AS�(^��b�.u�A��U;Ǝ�Y�{�u�9Ҷxd\�ǈ�#}/8���sr��8m�<f	��i��� =����4�+qz��	'�h>Cm��LBDy�Z|g����haڳ'�&Te p�� j��a���ЬG����l�]wZ����Ҟ)-K�z��͎���#JH;#)ɜ�H^�n�@B�<�+���z�Z��|����?3�����|��?>���+�/��_�������o�����#�.�A+�/������1����RP��������;����c[ A����+���ؤ�N?�0P>���v�����.�"K�$�"��"B�,J�$I�U���2�y�B�Xe�����T&��j�R��͉�1]0��cϑV�f?h�CO^��(���0�;uZI��!��h;��e>^�0�m�F9fl������#Bݞ��� ��|�q��g��Rrj��U��������~����(MT���������S�߱�CU������2�p��q���)x��$޾|Y9\.ǉJ�e�#���vЋ口R��-����������O�����]��,F,�8�M��M��b��b������,����,��h�PTʐ���?8r<��Z��|\���Et�RKD�D�ń���6�F��w9W���i�~�~q�g5�	^�뺻�V��KQ=�#r�1v��2��-ptˇ`�Oe��4v��U뙈k���6H0{0��j��������v�w�U���w��P�xj�Q^�e������K��*��2��������o���(�����_����΁X�qе
�%,�!?;�y<���%�������a�Ui��U��n�/���CwA�����h�� ���=hZ�a��-
'���N����B�N{Ġ�o�վml�8O`���L�z��"<c8x&'8�d�ub�ysD�������⢹���l�LT0�:����=�m�(����1��&1`[���&�0�BK<��9ޭ�+�F��5a��7�STY�M9�S�Kw*�vg<6� n-�y��<�K�In{.���}�?�� �'�)gSs��wu��{
mE6��l�q�s�2�)a�l�i��@�=��a�Sb3�=)�h���g�O�֪�Ys�P��ϋ�H���v�w��8^���෰�)����&|���An���(C������ǐ���/o��ѿ��1nۯ�x7w��i*�;<��}���{C��<3���#� ����} �'�@���-��) ��i����1~r��@���Nu7%�},mQI�����z�6�}�VzjJ���[3�c�҄�!��fL�9M���Tnx@A����㤯&��΃����� ��>t�����d��As�j$Z���ټK��i�^)�y�HVs��{�)��a���3[���Z����A{��h؄�=����O�y��S|���8��������R�[�����j�OI���_-��sP��߳�������|T������_���Q������ê�.���r��b�Ǩ�|��e�����+��s���X�)��������J���Ox�M���(�8�.C�F��O�L�8��C�O��#��b��`xu
�o�2�������_H�Z�)��J˔l99�[�Ԍa��"4����V�X�<�-j���c�鸭��+�{ɚ�zb��vp�*�(�9����Q���w-���3�(C�Sez��RGYl�C�j��{����O��%q�_�������-f���_����l�4+����_�_���v���W�Vsm�x�զ��_k�}�����N:u�\�뎡n(�
�F��+{�L��g��v����_�ϕ�jW5	p������U�o��v��zul���>���:�^ǿh�$����V��^z_k٤v���zZG�(�u��H�>�VӅ_{��O�C���q�h��/��NΫ]9������I�W��;u�6^l"�A]×�����Oq��˵=]���Ҏ�Q��7w�AE�[[�v�<-|��ʰ�-v���ꂨ��MCTEtn:r�U ���C�O?/�>^�r_�fW�v��kE%��|��^�q������\;�BϾ��.:J�'ߺ�o^--���DYrg��X����}�u��Y�E���K�2iA���^ܛ������Ӻ8�?��n���6��5x���ߟWe���?��ǒ߿���4����NM��t>]�7�4�Z��d�qb�'p��p8]O6�u��~0�I�^�=L|�	�!�#%pVϧ�� }T�#����Gdq�S7�X=��^��2)���7|�*��q$�C4dE��o��y\VGƷu��'�J1g�^WV�o��t���I��᭝��f	�-����D?}�'㶘���q��ۻ�X��:����\�J��.c����K�u/*�u��u[��)��t]��[{ڽԄ�`�K��I����D?h�/�%�A�!Fb�~@�n��ζsv�b���ӵ��O����￿�y�b��y0����M���i��������lt1<�d�$3�X�R2��q�ږ�c��'�k ��0�/����n�LˁiVFǢK��0н@4�׀�}2��lnr(aƅ|��yGU�$����C��m��hNԍ��+��Ah�ef�tðJ�@������8X�1�Ȓ�mE�uS�F�ޱJ�3v��qf�zxN�CI���3��dG:��B��LS�n9���^��U�#��!���q����8sq\��CS1��ȬJ�?P��-��oֈ�9|r��xiȘuTx�oU�K��nݜ�E��Y���Ma��M��4�"G�ӥ�l8���hpꛃS�N��N''F~0��|D��uru�N�_T$v �r�UY���`.�u���=�9��jL]�X�A-���,�n"I��,�T�>��V�?d9N�.[<g�tJ��a�yߌ�.#J#����_3�F?�+�ѽ^�ԚbTaFw��A�Y]}(�����%w���:L�Y)c�?fH�z��g �+V����Es��E�R$yP`k�lͼ�����r�������W?���޾���Q%�ق�p:�Xa��ι �g��{p�!���O�,�9����ҭ#2d�c�ǚ����.#&h����Lc<�M��N��ڹt|��w��j�2�]]��dC�ע��.�h�B��k�sˮ�܁�S��^UM���٧<4�7�":�Wv������,l���������5&��~�A�����?�~���C��vb�����~��W;��T���H��wy\� �� `�m/�������<`��m_���G�WA<��<��=<� '�:{{��;�����n�f�{������.=���A�P�
�V����	�¡:���`7.�x�Ə΁���g�A�>=qn���O@jrƦ����=��0G`$�Sܼ^���9�EE.Ag�]���l��0&���su�0�O!|0�x緙��(,��]>Pm9"���aw,Qv���f���vs�BD��N��f���)˽\�~�J�tA=L���0�b�z����d3����3�mN6t��$�g���9
SJt��0Q��i:KG;��zL���Dx�,�g��fQe��A_�46SE�E&�R�S�g�=J�7JyQ��a9Um	1!����`!�m�TU�X6�^/��8���K!
�ri?r��)�	k3am&�*LX��v;d ,�/�6�����]��[j�p��=5WB֭j��	��E�5%q�A@y��+�d��v�l��z\��Z���M�	��<�
m��h�H()f�d���	�8��̰ä�t93-8�v$�b-���u����X����&L�~`���X%�ZVj�X+��ҟ�E�,VӼx-�%�(i��i�yϰ�U��D�No'�B.H����!�c"�n���+K���e��3ʲ��l�R ˥�o�S)~w���i&?�|�G�E?õ��|�C�Y�կ��a��j�M*X�S����|*WVU�ܦ�,8#�y�(Q:\HUEӴ��㙖��S�=�3�K�%�z��GӾ!Ih]>F�
��i�:������MZ�SY�j1�݉*h?��U*���\�)�{�j��%�>WU\xo�%�HY�������WP�(����[.�����!A�M�I�3Ԛ����J��[xa�a5�+Ѣ���k'��r��7��FbRM 9�>����dM�"�Ue$�&�Jg���)��٥�6a�Ї�-V��i��
0�d�^�_k,!�ل��!��- ��lHꎏH���ʵ	)��ꞡ�&E�A	�'Y�4����i�l��f�l��l�p#�9QpMA��yU�>�[�ڀ֠S��kWl����~��2y��� 9t�ۧ�Cg��_9]U�g+��j�.p]�ms�b�;m�F�p���jj�������研,ոtt#��8^i�4:�q'���Ҽ�Vk�WZ���zB?÷���(<��'5Y�-'��lM�6䡛��k`�ᇟC�>��úM��9g�3kWA`�{��%s�4(�yV�U̖C�@����Z�c�<��,��i��S\V��ypW�/F>sz2+f�z�@t�'ʪ��L���Y ��f$}�Q��Y����GnE^�^��Z����[��R`���R���C�h����� �"	���t�B��[��g+;��p�Z�H����Ƣ���h�0�%k8z�`�K{�8�NZLOc�YS��{��A$�D��)��M��/�^��F,�J�.�▖h��D+�DCH�C�^��B"(t���-��G�s���I�+���a�B�S�C#{0p ���-&��|���q�����xH7��51"�%j���A�!�no<�`UW��b4SˑL#�a0җ����}B�.P����������a҂]�+[�k�a��9��!�	�}��-Q�")D�#��u�LS &�Co9���>.մb/��}��i�m�q�Ǻv�����t��)�������i�����ݡ�:��z贕a��xX�=,��[�O���޿���,�I��D�VD2S��Q
W�H���\���1/;���@����3�<X��u��E��$&���
��"�͚����x[��3��0jSI`bJى�!2(��d
G�vJ�Ԗ+�0���������]&�xY�p#�QnO���0<�}Q8]JI���t0do,6�!
��<��.�	�[j���g��;(EyrHԕ(t��+}t���<@�^�,���G��U����I^�È�2	��g�~����%��;��&&�$ι �ɒ�V��r�n���]�z��]�ye�6�8�ߌ�Pޏ{6ⷒS�>�S6�c���J!��l��f�.Ķ�(�����i���Q�h���tÔ��8��W**�i������>�%~���%A�oAlB�Ne����;��J�r�\�h��<NB'�+,7�"��]�>��7�Z/��i�~�[/=������Ky��C����fW���|7;ͦ�Տ�����w��>����,	87�>���<Hw_z�������oz��7���'������'����Sq�8��[׮4�~�W&W�t��FӉjh:�F��W~�c�|��;���8=�x�7���=	�N��(���)j�N��Yj�6�Ӧv��N�&`�lj������H�i��iS;mj����>����yh��e�^8�r��%���,4�6y�m!t�����o=fb褏���!��<��5�E���n��3�?�ڟRm��m�q�g<�#p$���d��zmj��2O˞3cG[�93�� {Z�=g�6�8.Ü�#��=���13��q��Z[����G���y\�R�����v����d��m�/	L��  